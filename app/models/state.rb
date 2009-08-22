class State < ActiveRecord::Base
  def self.[] state_type, name
    state_type = state_type.to_s
    name = name.to_s

    @cache ||= {}    
    @cache[[state_type,name]] ||= find(:first, :conditions => {:state_type => state_type, :name => name})
  end
end