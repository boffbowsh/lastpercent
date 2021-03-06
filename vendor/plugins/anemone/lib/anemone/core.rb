require 'net/http'
require 'thread'
require 'anemone/tentacle'
require 'anemone/page_hash'

module Anemone
  class Core
    # PageHash storing all Page objects encountered during the crawl
    attr_reader :pages
    
    #
    # Initialize the crawl with starting *urls* (single URL or Array of URLs)
    # and optional *block*
    #
    def initialize(urls, &block)
      @urls = [urls].flatten.map do |url| 
        url = URI(url) if url.is_a?(String) 
        
        # Make sure the initial string urls passed to Anemone have external flag set
        url.external = false if url.external.nil?
        url
      end
      @urls.each{ |url| url.path = '/' if url.path.empty? }
      # Follow redirects for urls before spidering
      begin
        @urls.map do |url|
          a = Anemone::HTTP.get( url )
          url.host = a[2].host if url.host != a[2].host
          url
        end
      rescue Exception => e
        puts "Error with urls [#{e}]"
      end
      
      
      @tentacles = []
      @pages = PageHash.new
      @on_every_page_blocks = []
      @on_pages_like_blocks = Hash.new { |hash,key| hash[key] = [] }
      @skip_link_patterns = []
      @after_crawl_blocks = []
      
      block.call(self) if block
    end
    
    #
    # Convenience method to start a new crawl
    #
    def self.crawl(root, &block)
      self.new(root) do |core|
        block.call(core) if block
        core.run
        return core
      end
    end
    
    #
    # Add a block to be executed on the PageHash after the crawl
    # is finished
    #
    def after_crawl(&block)
      @after_crawl_blocks << block
      self
    end
    
    #
    # Add one ore more Regex patterns for URLs which should not be
    # followed
    #
    def skip_links_like(*patterns)
      if patterns
        patterns.each do |pattern|
          @skip_link_patterns << pattern
        end
      end
      self
    end
    
    #
    # Add a block to be executed on every Page as they are encountered
    # during the crawl
    #
    def on_every_page(&block)
      @on_every_page_blocks << block
      self
    end
    
    #
    # Add a block to be executed on Page objects with a URL matching
    # one or more patterns
    #
    def on_pages_like(*patterns, &block)
      if patterns
        patterns.each do |pattern|
          @on_pages_like_blocks[pattern] << block
        end
      end
      self
    end
    
    #
    # Specify a block which will select which links to follow on each page.
    # The block should return an Array of URI objects.
    #
    def focus_crawl(&block)
      @focus_crawl_block = block
      self
    end
    
    #
    # Perform the crawl
    #
    def run
      @urls.delete_if { |url| !visit_link?(url) }
      return if @urls.empty?
      
      link_queue = Queue.new
      page_queue = Queue.new

      Anemone.options.threads.times do |id|
        @tentacles << Thread.new { Tentacle.new(link_queue, page_queue).run }
      end
      
      @urls.each{ |url| link_queue.enq(url) }

      loop do
        page = page_queue.deq
        
        @pages[page.url] = page
        
        puts "#{page.url} Queue: #{link_queue.size}" if Anemone.options.verbose
        
        #perform the on_every_page blocks for this page
        do_page_blocks(page)
        
        page.doc = nil if Anemone.options.discard_page_bodies
        
        links_to_follow(page).each do |link|
          # TODO : Add support for https links
          # Only follow http links
          # Only fetch url_limit number on links
          if URI::regexp(%w(http)).match( link.to_s ) &&
             link.is_allowed? &&
             ( Anemone.options.url_limit && Anemone.options.url_limit -= 1) > 0
            link_queue.enq(link)
          end
          @pages[link] = nil
        end

        
        #create an entry in the page hash for each alias of this page,
        #i.e. all the pages that redirected to this page
        page.aliases.each do |aka|
          if !@pages.has_key?(aka) or @pages[aka].nil?
            @pages[aka] = page.alias_clone(aka)
          end
          @pages[aka].add_alias!(page.url)
        end
        

        # puts "QSize [#{link_queue.size}] QWaiting [#{link_queue.num_waiting}] QEmpty [#{link_queue.empty?}]"
        # puts " TSize [#{@tentacles.size}] PWaiting [#{page_queue.num_waiting}] PEmpty [#{page_queue.empty?}]"
        # if we are done with the crawl, tell the threads to end
        
        if (link_queue.empty? && page_queue.empty?) || Anemone.times_up?
          if  Anemone.times_up?
             @tentacles.each { |t| t.kill }
             break
          else            
            until (link_queue.num_waiting == @tentacles.size) || Anemone.times_up?
              Thread.pass
            end
          
            if page_queue.empty?
              @tentacles.size.times { |i| link_queue.enq(:END) }
              break
            end
          end
        end
    
      end
      puts "We've finished"
      @tentacles.each { |t| t.join }

      do_after_crawl_blocks()
      
      # self
    end
    
    private    
    
    #
    # Execute the after_crawl blocks
    #
    def do_after_crawl_blocks
      @after_crawl_blocks.each {|b| b.call(@pages)}
    end
    
    #
    # Execute the on_every_page blocks for *page*
    #
    def do_page_blocks(page)
      @on_every_page_blocks.each do |blk|
        blk.call(page)
      end
      
      @on_pages_like_blocks.each do |pattern, blks|
        if page.url.to_s =~ pattern
          blks.each { |blk| blk.call(page) }
        end
      end
    end      
    
    #
    # Return an Array of links to follow from the given page.
    # Based on whether or not the link has already been crawled,
    # and the block given to focus_crawl()
    #
    def links_to_follow(page)
      links = @focus_crawl_block ? @focus_crawl_block.call(page) : page.links
      links.find_all { |link| visit_link?(link) }
    end
    
    #
    # Returns +true+ if *link* has not been visited already,
    # and is not excluded by a skip_link pattern. Returns
    # +false+ otherwise.
    #
    def visit_link?(link)
      !@pages.has_key?(link) and !skip_link?(link)
    end
    
    #
    # Returns +true+ if *link* should not be visited because
    # its URL matches a skip_link pattern.
    #
    def skip_link?(link)
      @skip_link_patterns.each { |p| return true if link.path =~ p}
      return false
    end
        
  end
end
