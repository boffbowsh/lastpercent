class Asset < ActiveRecord::Base
  # Associations
  belongs_to :site
  belongs_to :content_type
  has_many :checks
  has_many :results
  
  delegate :validators, :to => :content_type

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
    internal && content_type_id
  end

  def internal?
    !external?
  end

  def self.filter_by(params)
    if params[:content_type_id].present?
      scoped_by_content_type_id params[:content_type_id]
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
    File.join(RAILS_ROOT,'cached_assets',thousands.to_s,id.to_s.rjust(4,'0'))
  end

  def body
    @body ||= read_local_copy
  end

  def body= val
    @body = val
  end

  def save_local_copy
    filename = local_storage_filename
    FileUtils.mkdir_p File.dirname(filename)
    open(filename,'w') do |f|
      f.write @body
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
    File.unlink local_storage_filename
  end
end
