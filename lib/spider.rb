class Spider
  def self.crawl( site )
    anemone = Anemone.crawl( site.url ) do |core|
      core.on_every_page do |page|
        asset = site.assets.find_or_create_by_url( page.url.to_s )

        content_type = ContentType.find_or_create_by_mime_type( page.content_type )

        asset.update_attributes( :body => page.doc.to_s,
                                 :responce_status => page.code,
                                 :external => page.external, 
                                 :content_type_id => content_type.id )

        page.links.each do |link|
          child_asset = site.assets.find_or_create_by_url( link.to_s )
          asset.links << child_asset unless asset.link_ids.include?( child_asset.id )
        end
      end
    end
  end
end