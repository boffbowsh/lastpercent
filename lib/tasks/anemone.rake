desc 'Scan www.rawnet.com'
task :anemone => :environment do
  site = Site.first
  anemone = Anemone.crawl( site.url ) do |core|
    core.on_every_page do |page|
      
      # couldn't get find_and_create_by_ to work with multiple columns so rolled my own. Simples!
      asset = Asset.find_by_site_id_and_url( site.id, page.url.to_s )
      asset = Asset.create( :site_id =>  site.id, :url => page.url.to_s ) if asset.nil?
      
      
      asset.update_attributes( :body => page.doc.to_s, :responce_status => page.code, :external => page.external )
      page.links.each do |link|
        
        # couldn't get find_and_create_by_ to work with multiple columns so rolled my own. Simples!
        child_asset = Asset.find_by_site_id_and_url( site.id, link.to_s )
        child_asset = Asset.create( :site_id =>  site.id, :url => link.to_s  ) if child_asset.nil?

        asset.links << child_asset unless asset.links.include?( child_asset )
      end
    end
  end
end