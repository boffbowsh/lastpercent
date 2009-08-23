class Message < ActiveRecord::Base
  # Associations
  belongs_to :validator
  has_many :results

  # Validations
  validates_presence_of :body
  validates_presence_of :validator_id
  validates_associated :validator

  def to_s
    body
  end
end