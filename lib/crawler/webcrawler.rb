require 'set'
require 'observer'
require 'net/http'

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
      notify_observers(resp.code, uri.to_s)
      @crawled << uri
    end
  end
end