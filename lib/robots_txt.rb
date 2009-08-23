require "open-uri"
class RobotsTxt
  @rules
  
  def initialize( url, user_agent )
    @rules  = RobotRules.new( user_agent )

    url = url.chomp if url.last == '/'

    robots_url = File.join(url, "robots.txt")
    open(robots_url) do |url|
      data = url.read
      @rules.parse(robots_url, data)
    end
  rescue
    # Do nothing, just stop the checker bringing down the spider
  end
  
  def allowed? ( url )
    @rules.allowed?( url )
  end
  
end