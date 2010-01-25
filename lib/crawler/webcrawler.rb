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
    
    def crawl(start_uri)
      start_uri = start_uri.normalize
      @queue << start_uri
      
      while(uri = @queue.shift)
        resp = Net::HTTP.get_response(uri)

        changed
        notify_observers(resp, uri)
      
        html = Nokogiri.parse(resp.body)
        a_tags = html.search("a")
        @queue = @queue + a_tags.collect do |t| 
          next_uri = uri + t.attribute("href").to_s
          next_uri unless @crawled.include?(next_uri)
        end
        @queue = @queue.uniq
        @crawled << uri
      end
      
    end
  end
end