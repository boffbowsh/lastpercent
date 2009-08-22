class Result < ActiveRecord::Base
  # Associations
  belongs_to :check
  belongs_to :asset
  belongs_to :message

  # Validations
  validates_presence_of :check_id
  validates_presence_of :asset_id

  delegate :body, :to => :message
  delegate :validator_id, :validator, :to => :check

  before_validation_on_create :set_asset_id

  alias :to_s :body
  
  def body= val
    write_attribute :message_id, Message.find_or_create_by_validator_id_and_body(validator_id, val).id
  end
  
  def set_asset_id
    write_attribute :asset_id, check.asset_id
  end
end