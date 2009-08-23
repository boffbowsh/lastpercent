class Spider
  def self.crawl( site )
    anemone = Anemone.crawl( site.url, :url_limit => Settings.url_limit ) do |core|
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
          asset.links << child_asset unless asset.link_ids.include?( child_asset.id )
        end
      end
    end
  end
end