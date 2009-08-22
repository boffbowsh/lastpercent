class Check < ActiveRecord::Base
  belongs_to :asset
  belongs_to :validator
  belongs_to :worker
end