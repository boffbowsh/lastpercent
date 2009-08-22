class Site < ActiveRecord::Base
  # Associations
  belongs_to :user
  has_many :assets

  # Validations
  validates_presence_of :url
  validates_format_of :url, :with => URI::regexp(%w(http https))
  validates_presence_of :user_id
  validates_associated :user
  # validates_presence_of :verification_token

  def to_s
    name.blank? ? url : name
  end
end