require 'set'
require 'observer'

module Crawler
  class Webcrawler
    
    include Observable
    
    attr_accessor :crawled
    
    def initialize()
      @crawled = Set.new
    end
    
    def crawl(uri)
      changed
      notify_observers(200, uri.to_s)
      @crawled << uri
    end
  end
end