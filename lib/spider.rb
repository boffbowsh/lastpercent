
class Spider
  def self.crawl( site )
    user_agent = 'LastPercentBot'
    robot_txt = RobotsTxt.new( site.url, user_agent )
    
    site.update_attribute(:spider_started_at, Time.now)
    begin
      anemone = Anemone.crawl( site.url, :url_limit => Settings.url_limit, 
                                         :time_limit => Settings.time_limit, 
                                         :user_agent => user_agent ) do |core|
        core.focus_crawl do |page|
          page.links.each do |link|
            link.allowed = robot_txt.allowed? link.to_s
          end
        end

        core.on_every_page do |page|
          asset = site.assets.find_or_initialize_by_url( page.url.to_s )

          asset.attributes = { :data => FakeFile.from_anemone(page),
                               :response_status => page.code,
                               :external => page.external, 
                               :response_time => page.response_time }
          asset.save!
          
          page.links.each do |link|
            child_asset = site.assets.find_or_create_by_url( link.to_s )
            # asset.links << child_asset unless asset.link_ids.include?( child_asset.id )
          end
        end
      end
      site.update_attribute(:spider_ended_at, Time.now)
    rescue Exception => e
      puts e.to_s
      site.update_attribute(:spider_failed_at, Time.now)
    end
  end
end