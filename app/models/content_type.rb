class ContentType < ActiveRecord::Base
  # Associations
  has_many :assets
  has_and_belongs_to_many :validators

  # Validations
  validates_presence_of :mime_type
  validates_uniqueness_of :mime_type

  def to_s
    mime_type
  end
  
  def to_pretty_s
    mime_type.split('/')[1].gsub(/\+/, '-').downcase
  rescue
    mime_type
  end
end