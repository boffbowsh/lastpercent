require 'net/http'
require 'uri'

class Asset < ActiveRecord::Base
  # Associations
  belongs_to :site
  belongs_to :content_type
  has_many :checks, :dependent => :destroy
  has_many :results, :dependent => :destroy
  
  delegate :validators, :to => :content_type
  delegate :user, :to => :site

  has_and_belongs_to_many :links,
    :class_name => "Asset",
    :join_table => "links",
    :foreign_key => "from_asset_id",
    :association_foreign_key => "to_asset_id"

  validates_format_of :url, :with => URI::regexp(%w(http https))
  validates_uniqueness_of :url, :scope => :site_id
  validates_presence_of :site_id
  validates_presence_of :url

  after_update :enqueue

  after_save :save_local_copy
  
  named_scope :has_content_type, :conditions => 'content_type_id IS NOT NULL'
  named_scope :has_no_content_type, :conditions => 'content_type_id IS NULL'

  def enqueue
    Delayed::Job.enqueue self, 'Check' unless content_type.blank?
  end
  
  def content_type_id= val
    write_attribute(:content_type_id, val)
  end
  
  def mime_type
    content_type.try(:mime_type)
  end

  def create_checks
    if checkable?
      validators.active.each do |v|
        checks.find_or_create_by_validator_id v.id
      end
    end
  end

  alias :perform :create_checks

  def to_s
    internal? && path.present? ? path : url
  end
  
  def path
    url.gsub(site.url, '')
  end
  
  def checkable?
    internal? && content_type_id
  end

  def internal?
    !external?
  end

  def self.filter_by(params)
    if params[:content_type_id].present?
      scoped_by_content_type_id params[:content_type_id]
    elsif params[:response_status].present?
      scoped_by_response_status params[:response_status]
    else
      scoped
    end
  end
  
  def slow?
    if response_time
      response_time > 2000
    end
  end
  
  def errors_count
    results.errors.count
  end
  
  def warnings_count
    results.warnings.count
  end
  
  def infos_count
    results.infos.count
  end
  
  def valid?
    infos_count == 0 and warnings_count == 0 and errors_count == 0 and not /^[4|5|3]/.match(response_status.to_s)
  end

  define_index do
    # fields
    indexes :url

    # attributes
    has :created_at, :external, :response_status, :response_time
  end

  def local_storage_filename
    thousands = (id/1000).to_i * 1000
    File.join(RAILS_ROOT,'cached_assets',thousands.to_s.ljust(4,'0'),id.to_s.rjust(4,'0'))
  end

  def body
    @body ||= read_local_copy
  end

  def excerpt(line_no, column_no = nil, range = 10)
    if body
      count = 1
      excerpt = ""
      content = body
      content.each_line do |l|
        if count >= (line_no - range) && count <= (line_no + range)
          if count == line_no
            if column_no
              column_no -= 1
              l[column_no] = "STARTCOLSPANHERE#{l[column_no,1].to_s.gsub(/[\"><]|&(?!([a-zA-Z]+|(#\d+));)/) { |special| ERB::Util::HTML_ESCAPE[special] }}ENDCOLSPANHERE"
              l = "#{count}: <span class='current_line'>#{l.to_s.gsub(/[\"><]|&(?!([a-zA-Z]+|(#\d+));)/) { |special| ERB::Util::HTML_ESCAPE[special] }}</span>"
              l.gsub!('STARTCOLSPANHERE', "<span class='current_column'>")
              l.gsub!('ENDCOLSPANHERE', "</span>")
              excerpt << l
            else
              l = "#{count}: STARTLINESPANHERE#{l.rstrip.to_s.gsub(/[\"><]|&(?!([a-zA-Z]+|(#\d+));)/) { |special| ERB::Util::HTML_ESCAPE[special] }}ENDLINESPANHERE\n"
              l.gsub!('STARTLINESPANHERE', "<span class='current_line'>")
              l.gsub!('ENDLINESPANHERE', "</span>")
              excerpt << l
            end
          else
            excerpt << "#{count}: #{l.to_s.gsub(/[\"><]|&(?!([a-zA-Z]+|(#\d+));)/) { |special| ERB::Util::HTML_ESCAPE[special] }}"
          end
        end
        count += 1
      end
      # excerpt.gsub("\n", "<br />\n")
      excerpt
    end
  end

  def body= val
    @body = val
  end

  def save_local_copy
    if cache_data?
      filename = local_storage_filename
      FileUtils.mkdir_p File.dirname(filename)
      open(filename,'w') do |f|
        f.write @body
      end
    end
  end

  def read_local_copy
    filename = local_storage_filename
    if File.exists? filename
      open(filename,'r') do |f|
        @body = f.read
      end
    else
      @body = nil
    end
  end

  def destroy_local_copy!
    File.unlink local_storage_filename if File.exist? local_storage_filename
  end

  def cache_data?
    cache_array = %w{ text/xml text/plain text/html text/css application/atom+xml application/rss+xml application/xml }
    cache_array.include? self.mime_type
  end
  
  def fetch!
    destroy_local_copy!
    uri = URI.parse url
    res = nil
    realtime = Benchmark.realtime do
      res = Net::HTTP.start(uri.host, uri.port) {|http| http.get(uri.path)}
    end
    
    content_type = ContentType.find_or_create_by_mime_type( res.content_type )
    
    self.attributes = { :body => res.body.to_s,
                         :response_status => res.code,
                         :content_type_id => content_type.id,
                         :content_length => res.body.size,
                         :response_time => realtime*1000 }
    self.save
    self.enqueue
  end
end
