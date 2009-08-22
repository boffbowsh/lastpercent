desc 'Scan www.rawnet.com'
task :anemone => :environment do
  site = Site.first
  Spider.crawl( site )
end