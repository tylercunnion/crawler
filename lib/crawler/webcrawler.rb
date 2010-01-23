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
      
      resp = Net::HTTP.get_response(uri)
      
      changed
      notify_observers(resp, uri.to_s)
      @crawled << @queue.pop
      
      html = Nokogiri.parse(resp.body)
      a_tags = html.search("a")
      a_tags.each { |t| @crawled << uri + t.attribute("href").to_s }
      
    end
  end
end