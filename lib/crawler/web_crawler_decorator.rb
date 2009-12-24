module Crawler
  class WebCrawlerDecorator
    extend Forwardable
    
    def_delegators :@base_crawler, :search, :process_neighbors, :before_get_neighbors
    
    def initialize(base_crawler)
      @base_crawler = base_crawler
    end
    
    
  end
end