module Anemone
  class ImgTag < Link

    class <<self
      def find_links_in(page)
        find_links_for( page, 'img', 'src' )
      end
    end
  end
end