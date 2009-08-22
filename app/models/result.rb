class Result < ActiveRecord::Base
  # Associations
  belongs_to :check
  belongs_to :asset
  belongs_to :message

  # Validations
  validates_presence_of :check_id
  validates_presence_of :asset_id

  delegates :body, :to => :message
  delegates :validator_id, :to => :check

  before_validation_on_create :set_asset_id

  alias :to_s :body
  
  def body= val
    message = Message.find_or_create_by_validator_id_and_body(validator_id, var)
  end
  
  def set_asset_id
    write_attribute(:asset_id, check.asset_id)
  end
end