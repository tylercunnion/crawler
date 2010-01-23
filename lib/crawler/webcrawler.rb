require 'set'
require 'observer'
require 'net/http'
require 'nokogiri'

module Crawler
  class Webcrawler
    
    include Observable
    
    attr_accessor :crawled
    
    def initialize()
      @crawled = Set.new
    end
    
    def crawl(uri)
      resp = Net::HTTP.get_response(uri)
      
      changed
      notify_observers(resp, uri.to_s)
      @crawled << uri
      
      html = Nokogiri.parse(resp.body)
      a_tags = html.search("a")
      a_tags.each { |t| @crawled << uri + t.attribute("href").to_s }
      
    end
  end
end