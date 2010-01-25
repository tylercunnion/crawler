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
    # Queue of URIs to be crawled. Array which acts as a LIFO queue.
    attr_accessor :queue
    # Hash of options
    attr_accessor :options
    
    # Accepts the following options:
    # * timeout -- Time limit for the crawl operation, after which a Timeout::Error exception is raised.
    def initialize(options={})
      @crawled = Set.new
      @queue = []
      @options = {
        :timeout => 1.0/0, #Infinity
        :external => false
      }.merge(options)
      
    end
    
    # Given a URI object, the crawler will explore every linked page recursively using the Breadth First Search algorithm.
    def crawl(start_uri)
      start_uri = start_uri.normalize
      @queue << start_uri
      
      timeout(@options[:timeout]) {
        while(uri = @queue.shift)
          resp = Net::HTTP.get_response(uri)

          changed
          notify_observers(resp, uri)
      
          html = Nokogiri.parse(resp.body)
          a_tags = html.search("a")
          @queue = @queue + a_tags.collect do |t| 
            next_uri = uri + t.attribute("href").to_s.strip
            next_uri unless @crawled.include?(next_uri) or next_uri == uri or !(next_uri.kind_of?(URI::HTTP)) or (next_uri.host != uri.host and !@options[:external])
          end
          @queue = @queue.compact.uniq
          @crawled << uri
        end
      }
      
    end
  end
end