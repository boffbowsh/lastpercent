require 'benchmark'
require 'aasm'

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
  
  after_create :enqueue
  
  def enqueue
    Delayed::Job.enqueue self
  end
  
  def perform
    self.started_at = Time.now
    begin!
    
    validator_object = validator.validator_class.new self
    
    validator_results = nil
    realtime = Benchmark.realtime do
      validator_object.run
    end
    
    validator_object.results.each do |validator_result|
      result = results.build
      result.attributes = validator_result
      result.save
    end
    
    self.duration = realtime * 1000
    self.worker = Worker.find_by_name!(Delayed::Job.worker_name)
    save!
    complete!
  end
end