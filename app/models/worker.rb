class Worker < ActiveRecord::Base
  include AASM
  include AASMTable
  
  belongs_to :state
  
  aasm_state :disabled
  aasm_state :enabled
  
  aasm_event(:enable) { transitions :to => :enabled, :from => :disabled }
  aasm_event(:disable) { transitions :to => :disabled, :from => :enabled }
end