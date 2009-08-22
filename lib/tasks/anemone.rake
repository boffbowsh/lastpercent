desc 'Scan www.rawnet.com'
task :anemone => :environment do
  Spider.crawl( Site.first )
end