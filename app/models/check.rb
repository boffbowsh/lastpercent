class Check < ActiveRecord::Base
  belongs_to :asset
  belongs_to :validator
  belongs_to :worker

  def perform
    self.worker = Worker.find_by_name!(Delayed::Job.worker_name)
    save!
  end
end