module Anemone
  class LinkTag < Link

    class <<self
      def find_links_in(page)
        find_links_for( page, 'link', 'href' )
      end
    end
  end
end