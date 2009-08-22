class Site < ActiveRecord::Base
  belongs_to :user

  has_many :assets

  def to_s
    url
  end
end