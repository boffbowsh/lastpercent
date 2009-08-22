class Validator < ActiveRecord::Base
  # Associations
  has_many :checks
  has_many :results

  # Validations
  validates_presence_of :name
  validates_presence_of :class_name
  validates_uniqueness_of :class_name
  validates_presence_of :description
  validates_inclusion_of :active, :in => [true, false]
  validates_presence_of :permalink
  validates_uniqueness_of :permalink
end