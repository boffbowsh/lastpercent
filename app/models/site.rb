class Site < ActiveRecord::Base
  # Associations
  belongs_to :user
  has_many :assets
  has_many :results, :through => :assets

  # Validations
  validates_presence_of :url
  validates_format_of :url, :with => URI::regexp(%w(http https))
  validates_presence_of :user_id
  validates_associated :user
  # validates_presence_of :verification_token

  def to_s
    name.blank? ? url : name
  end

  after_create :spider

  def spider
    anemone = Anemone.crawl(url) do |core|
      core.on_every_page do |page|

        asset = assets.find_or_create_by_url(page.url.to_s)
        asset.update_attributes( :body => page.doc.to_s, :responce_status => page.code, :external => page.external )
        page.links.each do |link|
          child_asset = assets.find_or_create_by_url( link.to_s )
          asset.links << child_asset unless asset.links.include?( child_asset )
        end
      end
    end
  end
end