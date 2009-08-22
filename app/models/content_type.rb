class ContentType < ActiveRecord::Base
  # Associations
  has_many :assets

  # Validations
  validates_presence_of :mime_type
  validates_uniqueness_of :mime_type
end