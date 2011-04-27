require 'set'
require 'observer'
require 'net/http'
require 'nokogiri'
require 'timeout'

module Crawler
  class Webcrawler
    
    include Observable
    
    # Set of all URIs which have been crawled
    attr_accessor :crawled
    # Queue of URIs to be crawled. Array which acts as a FIFO queue.
    attr_accessor :queue
    # Hash of options
    attr_accessor :options
    
    # Accepts the following options:
    # * timeout -- Time limit for the crawl operation, after which a Timeout::Error exception is raised.
    # * external -- Boolean; whether or not the crawler will go outside the original URI's host.
    # * exclude -- A URI will be excluded if it includes any of the strings within this array.
    # * useragent -- User Agent string to be transmitted in the header of all requests
    def initialize(options={})
      @crawled = Set.new
      @queue = []
      @options = {
        :timeout => 1.0/0, #Infinity
        :external => false,
        :exclude => [],
        :useragent => "Ruby Crawler/" + Crawler::VERSION
      }.merge(options)
      
    end
    
    # Given a URI object, the crawler will explore every linked page recursively using the Breadth First Search algorithm.
    # Whenever it downloads a page, it notifies observers with an HTTPResponse subclass object and the downloaded URI object.
    def crawl(start_uri)
      start_uri = start_uri.normalize
      @queue << start_uri
      
      timeout(@options[:timeout]) {
        while(uri = @queue.shift)
          
          Net::HTTP.start(uri.host, uri.port) do |http|
            
            headers = {
              'User-Agent' => @options[:useragent]
            }
            
            head = http.head(uri.path, headers)
            next if head.content_type != "text/html" # If the page retrieved is not an HTML document, we'll choke on it anyway. Skip it
            
            resp = http.get(uri.path, headers)

            changed
            notify_observers(resp, uri)
      
            html = Nokogiri.parse(resp.body)
            a_tags = html.search("a")
            @queue = @queue + a_tags.collect do |t|
              begin
                next_uri = uri + t.attribute("href").to_s.strip
              rescue
                nil
              end
            end
            @queue = @queue.compact.uniq
            @queue = @queue.reject {|u| 
              @crawled.include?(u) or
              u == uri or
              !(u.kind_of?(URI::HTTP)) or
              (u.host != uri.host and !@options[:external]) or
              (@options[:exclude].any? { |excl| u.path.include?(excl)})
            }
          end
          @crawled << uri
        end
      }
      
    end
  end
end
