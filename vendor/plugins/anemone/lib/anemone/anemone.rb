require 'ostruct'
require 'anemone/core'

module Anemone
  # Version number
  VERSION = '0.1.2'

  #module-wide options
  def Anemone.options=(options)
    @options = options
  end
  
  def Anemone.options
    @options
  end
  
  #
  # Convenience method to start a crawl using Core
  #
  def Anemone.crawl(urls, options = {}, &block)
    Anemone.options = OpenStruct.new(options)
	  
	  
    #by default, run 4 Tentacle threads to fetch pages
    Anemone.options.threads ||= 4
	
    #disable verbose output by default
    Anemone.options.verbose ||= false
	
    #by default, don't throw away the page response body after scanning it for links
    Anemone.options.discard_page_bodies ||= false

    #by default, identify self as Anemone/VERSION
    Anemone.options.user_agent ||= "Anemone/#{self::VERSION}"   

    #no delay between requests by default
    Anemone.options.delay ||= 0
    
    # By default only fetch 10 urls
    Anemone.options.url_limit ||= 70
    
    # By default stop the spider after 30 seconds
	  Anemone.options.start_time = Time.now.to_i
    Anemone.options.time_limit ||= 30
    
    # Not sure this is required as each thread will be throattled by the delay
    # #use a single thread if a delay was requested
    # if(Anemone.options.delay != 0)
    #   Anemone.options.threads = 1
    # end
    
    Core.crawl(urls, &block)
  end
  
  def self.times_up?
    # There is no time_limit if time_limit == false
    return false unless Anemone.options.time_limit
    
    # Calculate how long the crawl has been running and if the time_limit has been reached
    runtime_seconds = Time.now.to_i - Anemone.options.start_time
    Anemone.options.time_limit <= runtime_seconds
  end
  
end
