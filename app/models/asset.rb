class Asset < ActiveRecord::Base
  # Associations
  belongs_to :site
  belongs_to :content_type
  has_many :checks
  has_many :results

  has_and_belongs_to_many :links, 
                          :class_name => "Asset",
                          :join_table => "links", 
                          :foreign_key => "from_asset_id",
                          :association_foreign_key => "to_asset_id"

  validates_format_of :url, :with => URI::regexp(%w(http https))
  validates_uniqueness_of :url, :scope => :site_id
  validates_presence_of :site_id
  validates_presence_of :url

  def to_s
    url
  end
end
