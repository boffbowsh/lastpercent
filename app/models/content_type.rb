class ContentType < ActiveRecord::Base
  # Associations
  has_many :assets

  # Validations
  validates_presence_of :mime_type
  validates_uniqueness_of :mime_type

  before_save :sanitize

  def sanitize
    self.mime_type = self.mime_type.split(';').first
  end
end