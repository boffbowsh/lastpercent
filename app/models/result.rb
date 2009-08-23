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
  delegate :user, :to => :asset

  before_validation_on_create :set_asset_id

  named_scope :errors, :conditions => {:severity => 2}
  named_scope :warnings, :conditions => {:severity => 1}
  named_scope :infos, :conditions => {:severity => 0}

  alias :to_s :body

  def body= val
    write_attribute :message_id, Message.find_or_create_by_validator_id_and_body(validator_id, val).id
  end

  def set_asset_id
    write_attribute :asset_id, check.asset_id
  end
  
  def error?
    severity == 2
  end
  
  def warning?
    severity == 1
  end
  
  def info?
    severity == 0
  end
  
  def self.filter_by(params)
    if params[:severity].present?
      scoped_by_severity params[:severity]
    else
      scoped
    end
  end
end