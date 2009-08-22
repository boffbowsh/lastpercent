require 'benchmark'

class Check < ActiveRecord::Base
  include AASM
  include AASMTable
  
  aasm_state :pending
  aasm_state :running
  aasm_state :completed
  aasm_state :failed
  
  aasm_event(:begin) { transitions :from => :pending, :to => :running }
  aasm_event(:complete) { transitions :from => :running, :to => :completed }
  aasm_event(:fail) { transitions :from => :running, :to => :failed }
  
  belongs_to :asset
  belongs_to :validator
  belongs_to :worker
  
  belongs_to :state
  
  has_many :results

  def perform
    self.started_at = Time.now
    begin!
    
    validator_object = validator.validator_class.new self
    
    realtime = Benchmark.realtime do
      validator_results = validator_object.run
    end
    
    validator_results.each do |validator_result|
      results.create validator_result
    end
    
    self.duration = realtime
    self.worker = Worker.find_by_name!(Delayed::Job.worker_name)
    save!
    completed!
  end
  
  def fail
    fail!
  end
end