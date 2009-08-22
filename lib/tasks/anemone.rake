desc 'Scan www.rawnet.com'
task :anemone => :environment do
  site = Site.first
  anemone = Anemone.crawl( site.url ) do |core|
    core.on_every_page do |page|
      
      # couldn't get find_and_create_by_ to work with multiple columns so rolled my own. Simples!
      asset = site.assets.find_by_url( page.url.to_s )
      asset = site.assets.create( :url => page.url.to_s ) if asset.nil?
      
      content_type = ContentType.find_or_create_by_mime_type( page.content_type )
      
      asset.update_attributes( :body => page.doc.to_s, 
                               :responce_status => page.code, 
                               :external => page.external, 
                               :content_type_id => content_type.id )
                               
      page.links.each do |link|
        
        # couldn't get find_and_create_by_ to work with multiple columns so rolled my own. Simples!
        child_asset = site.assets.find_by_url( site.id, link.to_s )
        child_asset = site.assets.create( :url => link.to_s  ) if child_asset.nil?

        asset.links << child_asset unless asset.links.include?( child_asset )
      end
    end
  end
end