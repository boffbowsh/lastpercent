require 'anemone/page'

module Anemone
  class Tentacle
    
    #
    # Create a new Tentacle
    #
    def initialize(link_queue, page_queue)
      @link_queue = link_queue
      @page_queue = page_queue
    end
    
    #
    # Gets links from @link_queue, and returns the fetched
    # Page objects into @page_queue
    #
    def run
      while true do
        link = @link_queue.deq
        break if (link == :END) || Anemone.times_up?

        page = Page.fetch(link)
        @page_queue.enq(page) unless page.nil?

        sleep Anemone.options.delay unless Anemone.times_up?
      end
    end
    
  end
end