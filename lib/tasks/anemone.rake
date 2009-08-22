desc 'Scan www.rawnet.com'
task :anemone => :environment do
  anemone = Anemone.crawl( 'http://skp.paul.rawnet.local' ) do |core|
    core.on_every_page do |page|

      asset = Asset.find_or_create_by_url(page.url.to_s)
      asset.update_attributes( :body => page.doc.to_s, :responce_status => page.code, :external => page.external )
      page.links.each do |link|
        child_asset = Asset.find_or_create_by_url( link.to_s )
        asset.links << child_asset unless asset.links.include?( child_asset )
      end
    end
  end
end