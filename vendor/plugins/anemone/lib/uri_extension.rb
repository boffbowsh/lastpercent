module URI
  attr_accessor :external
  attr_accessor :allowed
  
  def is_external?
    @external
  end

  def is_allowed?
    @allowed
  end
    
end
