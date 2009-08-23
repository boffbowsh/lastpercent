class Site < ActiveRecord::Base
  # Associations
  belongs_to :user
  has_many :assets
  has_many :results, :through => :assets
  has_many :info_reports, :through => :assets, :class_name => 'Report', :conditions => {:severity => 0}
  has_many :warning_reports, :through => :assets, :class_name => 'Report', :conditions => {:severity => 1}
  has_many :error_reports, :through => :assets, :class_name => 'Report', :conditions => {:severity => 2}
  has_many :content_types, :through => :assets, :uniq => true

  # Validations
  validates_presence_of :url
  validates_format_of :url, :with => URI::regexp(%w(http https))
  validates_presence_of :user_id
  validates_associated :user
  # validates_presence_of :verification_token

  def to_s
    name.blank? ? url : name
  end

  after_create :enqueue

  def enqueue
    Delayed::Job.enqueue self
  end

  def spider
    Spider.crawl self
  end

  alias :perform :spider
end