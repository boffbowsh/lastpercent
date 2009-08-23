require 'anemone/http'
require 'anemone/link'


module Anemone
  class Page

    # The URL of the page
    attr_reader :url
    # Array of distinct A tag HREFs from the page
    attr_reader :links
    # Headers of the HTTP response
    attr_reader :headers
    
    # OpenStruct for user-stored data
    attr_accessor :data
    # Doc to hold the HTML body
    attr_accessor :doc
    # Integer response code of the page
    attr_accessor :code	
    # Array of redirect-aliases for the page
    attr_accessor :aliases
    # Boolean indicating whether or not this page has been visited in PageHash#shortest_paths!
    attr_accessor :visited
    # Used by PageHash#shortest_paths! to store depth of the page
    attr_accessor :depth
    # Flag page as external
    attr_accessor :external
    # MediumInt used to hold the size of the asset in bytes
    attr_accessor :content_length
    # Integer used to hold the response time in fetching the asset from the given url
    attr_accessor :response_time
    
    #
    # Create a new Page from the response of an HTTP request to *url*
    #
    def self.fetch(url)
      begin
        url = URI(url) if url.is_a?(String)
        
        response = nil
        code = nil
        location = nil
        response_time = 100 * Benchmark.realtime do
          response, code, location = Anemone::HTTP.get(url)
        end
              
        aka = nil
        if location && !url.eql?(location)
          aka = location
        end
        
        if response.nil? # The was no response from the server
          return Page.new(url)
        elsif url.is_external?
          return Page.new(url, nil, code, response.to_hash, aka, response_time)
        else
          return Page.new(url, response.body, code, response.to_hash, aka, response_time)
        end
      rescue
        return Page.new(url)
      end
    end
    
    #
    # Create a new page
    #
    def initialize(url, body = nil, code = nil, headers = nil, aka = nil, response_time = nil)
      @url = url
      @code = code
      @headers = headers
      @links = []
      @aliases = []
      @data = OpenStruct.new
      @external = url.is_external?
      @content_length = headers['content-length'].first if headers && headers['content-length']
      @response_time = response_time
      	  
      @aliases << aka if !aka.nil?

      if body
        begin
          @doc = body
        rescue
          return
        end

        return if @doc.nil?
        
        if self.html?
          Link.find_all_links_in(self) 
        end
        
        @links.uniq!
      end
    rescue Exception => exp
      puts "An error occured [#{exp}]"
      Page.new(url)
    end
    
    
    #
    # Return a new page with the same *response* and *url*, but
    # with a 200 response code
    #    
    def alias_clone(url)
      p = clone
	  p.add_alias!(@aka) if !@aka.nil?
	  p.code = 200
	  p
    end

    #
    # Add a redirect-alias String *aka* to the list of the page's aliases
    #
    # Returns *self*
    #
    def add_alias!(aka)
      @aliases << aka if !@aliases.include?(aka)
      self
    end
    
    #
    # Returns an Array of all links from this page, and all the 
    # redirect-aliases of those pages, as String objects.
    #
    # *page_hash* is a PageHash object with the results of the current crawl.
    #
    def links_and_their_aliases(page_hash)
      @links.inject([]) do |results, link|
        results.concat([link].concat(page_hash[link].aliases))
      end
    end
    
    #
    # The content-type returned by the HTTP request for this page
    #
    def content_type
      return blank_type if @headers.nil?
      
      # if no content type is supplied return and empty string instead of nil
      Page.content_type_sanitize( @headers['content-type'] ) 
    end
    
    #
    # Returns +true+ if the page is a HTML document, returns +false+
    # otherwise.
    #
    def html?
      Page.html? content_type
    end
    
    #
    # Returns +true+ if the page is a HTTP redirect, returns +false+
    # otherwise.
    #    
    def redirect?
      (300..399).include?(@code)
    end
    
    #
    # Returns +true+ if the page was not found (returned 404 code),
    # returns +false+ otherwise.
    #
    def not_found?
      404 == @code
    end

    def self.content_type_sanitize( dirty_mime_type )
      return blank_type if dirty_mime_type.nil?
      
      mime_type = dirty_mime_type[0] if dirty_mime_type.is_a?(Array)
      mime_type.split(';').first rescue blank_type
    end
    
    def self.html?( mime_type )
    (mime_type =~ /text\/html/) == 0
    end
    
    def blank_type
      "BLANK"
    end
    
  end
end
