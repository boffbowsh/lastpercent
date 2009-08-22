require 'anemone/http'
require 'anemone/link'
require 'nokogiri'
require 'ostruct'

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
    # Nokogiri document for the HTML body
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
        if !url.eql?(location)
          aka = location
        end
        
        if url.is_external?
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
          @doc = Nokogiri::HTML(body)
        rescue
          return
        end

        return if @doc.nil?
        
        Link.find_all_links_in(self) 
        
        @links.uniq!
      end
    rescue Exception => exp
      puts "An error occured [#{exp}]"
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
      @headers['content-type'][0] rescue nil
    end
    
    #
    # Returns +true+ if the page is a HTML document, returns +false+
    # otherwise.
    #
    def html?
      (@content_type =~ /text\/html/) == 0
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
    
    
  end
end
