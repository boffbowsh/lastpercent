
class Spider
  def self.crawl( site )
    user_agent = 'LastPercentBot'
    robot_txt = RobotsTxt.new( site.url, user_agent )
    
    site.update_attribute(:spider_started_at, Time.now)
    begin
      anemone = Anemone.crawl( site.url, :url_limit => 10, :user_agent => user_agent ) do |core|
        core.focus_crawl do |page|
          page.links.each do |link|
            link.allowed = robot_txt.allowed? link.to_s
          end
        end

        core.on_every_page do |page|
          asset = site.assets.find_or_initialize_by_url( page.url.to_s )

          content_type = ContentType.find_or_create_by_mime_type( page.content_type )

          asset.attributes = { :body => page.doc.to_s,
                               :response_status => page.code,
                               :external => page.external, 
                               :content_type_id => content_type.id,
                               :content_length => page.content_length,
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
      puts e
      site.update_attribute(:spider_failed_at, Time.now)
    end
  end
end