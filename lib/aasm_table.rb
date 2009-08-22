module AASMTable
  def self.included base
    base.send(:define_method, "#{base.aasm_column}=") do |state|
      unless state.is_a? State
        state = State[base, state]
      end
      self.send("#{self.class.aasm_state_relationship}=", state)
    end

    base.send(:define_method, "#{base.aasm_column}") do
      self.send(self.class.aasm_state_relationship).try(:name).try(:to_sym)
    end

    base.extend ClassMethods
    base.aasm_state_relationship = :state
  end

  def aasm_read_state
    if new_record?
      send(self.class.aasm_column).blank? ? aasm_determine_state_name(self.class.aasm_initial_state) : send(self.class.aasm_column)
    else
      send(self.class.aasm_column).nil? ? nil : send(self.class.aasm_column)
    end
  end

  def aasm_write_state state
    old_value = send(self.class.aasm_column)
    send("#{self.class.aasm_column}=", state)

    unless self.save(false)
      send("#{self.class.aasm_column}=", old_value)
      return false
    end

    true
  end

  module ClassMethods
    attr_accessor :aasm_state_relationship
    
    def self.aasm_state_relationship rel=nil
      if rel.nil?
        aasm_state_relationship
      else 
        aasm_state_relationship = rel
      end
    end
  end
end