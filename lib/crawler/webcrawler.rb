require 'set'
require 'observer'
require 'net/http'
require 'nokogiri'
require 'timeout'

module Crawler
  class Webcrawler
    
    include Observable
    
    attr_accessor :crawled
    attr_accessor :queue
    attr_accessor :options
    
    def initialize(options={})
      @crawled = Set.new
      @queue = []
      @options = {
        :timeout => 1.0/0 #Infinity
      }.merge(options)
      
    end
    
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
            next_uri unless @crawled.include?(next_uri) or next_uri == uri or !(next_uri.kind_of?(URI::HTTP))
          end
          @queue = @queue.compact.uniq
          @crawled << uri
        end
      }
      
    end
  end
end