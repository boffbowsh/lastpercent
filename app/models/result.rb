class Result < ActiveRecord::Base
  # Associations
  belongs_to :check
  belongs_to :asset
  belongs_to :message

  # Validations
  validates_presence_of :check_id
  validates_presence_of :asset_id
end