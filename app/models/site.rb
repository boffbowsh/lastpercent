class Site < ActiveRecord::Base
  # Associations
  belongs_to :user
  has_many :assets, :dependent => :destroy
  has_many :results, :through => :assets
  has_many :content_types, :through => :assets, :uniq => true

  # Validations
  validates_presence_of :url
  validates_format_of :url, :with => URI::regexp(%w(http https))
  validates_presence_of :user_id
  validates_associated :user
  # validates_presence_of :verification_token
  validate :not_reached_site_limit

  def to_s
    name.blank? ? url : name
  end

  def not_reached_site_limit
    errors.add('url', "Max site limit reached (during beta)") if user.sites.count >= Settings.max_site_limit
  end

  def assets_count
    assets.count
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
  
  def successes_count
    assets_without_errors.count
  end

  # TODO: REWRITE ME OMG REWRITE ME
  def assets_with_errors
    Asset.find(:all, :select => 'distinct assets.*', :joins => 'INNER JOIN results ON results.asset_id = assets.id', :conditions => ['assets.site_id = ? AND results.severity = 2', self.id])
  end

  # TODO: REWRITE ME OMG REWRITE ME
  def assets_with_warnings
    Asset.find(:all, :select => 'distinct assets.*', :joins => 'INNER JOIN results ON results.asset_id = assets.id', :conditions => ['assets.site_id = ? AND results.severity = 1', self.id])
  end

  # TODO: REWRITE ME OMG REWRITE ME
  def assets_without_errors
    Asset.find(:all, :select => 'distinct assets.*', :joins => 'LEFT OUTER JOIN results ON results.asset_id = assets.id', :conditions => [' assets.site_id = ? AND results.id IS NULL', self.id])
  end

  def percentage_of_assets_with_errors
    assets_with_errors.size.to_f / assets_count
  end

  def percentage_of_assets_with_warnings
    assets_with_warnings.size.to_f / assets_count
  end

  def percentage_of_assets_without_errors
    assets_without_errors.size.to_f / assets_count
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