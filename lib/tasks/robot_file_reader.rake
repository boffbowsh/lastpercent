require "open-uri"
desc 'Test reading robot.txt into Anemone'
task :robot_reader => :environment do
  site   = Site.first
  rules  = RobotRules.new("RubyQuizBrowser 1.0")

  url = site.url
  url = url.chomp if url.last == '/'

  robots_url = File.join(url, "robots.txt")
  puts robots_url.class
  open(robots_url) do |url|
    data = url.read
    rules.parse(robots_url, data)
  end
  
  
  %w{ http://dateline.hosting.rawnet.com/images/dave.jpg
       http://dateline.hosting.rawnet.com/imagination }.each do |test|
     puts "rules.allowed?( #{test.inspect} )"
     puts rules.allowed?(test)
  end
  
end


