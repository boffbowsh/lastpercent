module Anemone
  class ScriptTag < Link

    class <<self
      def find_links_in(page)
        find_links_for( page, 'script', 'src' )
      end
    end
  end
end