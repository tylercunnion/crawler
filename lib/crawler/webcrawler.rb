require 'set'
require 'observer'
require 'net/http'
require 'nokogiri'

module Crawler
  class Webcrawler
    
    include Observable
    
    attr_accessor :crawled
    attr_accessor :queue
    
    def initialize()
      @crawled = Set.new
      @queue = []
    end
    
    def crawl(uri)
      @queue << uri
      
      while(next_uri = @queue.shift)
        resp = Net::HTTP.get_response(next_uri)
            
        changed
        notify_observers(resp, next_uri.to_s)
      
        html = Nokogiri.parse(resp.body)
        a_tags = html.search("a")
        @queue = @queue + a_tags.collect { |t| next_uri + t.attribute("href").to_s }
        @crawled << next_uri
      end
      
    end
  end
end