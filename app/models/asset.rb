class Asset < ActiveRecord::Base
  # Associations
  belongs_to :site
  belongs_to :content_type
  has_many :checks
  has_many :results

  delegate :validators, :mime_type, :to => :content_type

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

  def enqueue
    Delayed::Job.enqueue self unless mime_type.blank?
  end

  def create_checks
    validators.active.each do |v|
      checks.find_or_create_by_validator_id v.id
    end
  end

  alias :perform :create_checks

  def to_s
    url
  end
end
