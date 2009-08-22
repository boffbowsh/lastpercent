module Anemone
  class ATag < Link

    class <<self
      def find_links_in(page)
        find_links_for( page, 'a', 'href' )
      end
    end
  end
end