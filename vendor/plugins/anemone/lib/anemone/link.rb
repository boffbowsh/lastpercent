module Anemone
  class Link
    class <<self
      # def require_link_classes()
      #   dirname = File.dirname(__FILE__) + '/link'
      #   Dir.open( dirname ).each do |fn|
      #     next unless ( fn =~ /[.]rb$/ )
      #     require "#{dirname}/#{fn}"
      #   end
      # end
      
      # Use loaded subclasses of Link to search for more resources in the current page
      def find_all_links_in(page)
        subclasses.each do |sc|
          # puts "SUBCLASS [#{sc}]"
          sc.constantize.find_links_in(page)
        end
      rescue Exception => exp
        puts exp
      end
      
      def find_links_for(page, tag_name, attr_name)
        #get a list of distinct links on the page, in absolute url form
        page.doc.css(tag_name).each do |a| 
          u = a.attributes[attr_name].content if a.attributes[attr_name]
          next if u.nil?

          begin
            abs = to_absolute(page, URI(u))
          rescue
            next
          end
          
          # flag the link as external and add it to the link list
          abs.external = !in_domain?(page, abs)

          page.links << abs
        end
      rescue Exception => exp
        puts exp
      end

      #
      # Converts relative URL *link* into an absolute URL based on the
      # location of the page
      #
      def to_absolute(page, link)
        # remove anchor
        link = URI.encode(link.to_s.gsub(/#[a-zA-Z0-9_-]*$/,''))

        relative = URI(link)
        absolute = page.url.merge(relative)

        absolute.path = '/' if absolute.path.empty?

        return absolute
      end

      #
      # Returns +true+ if *uri* is in the same domain as the page, returns
      # +false+ otherwise
      #
      def in_domain?(page, uri)
        uri.host == page.url.host
      end
    end
  end

end
