module Crawler
  
  # Observer watches a Webcrawler and outputs messages to a log object. This defaults to STDOUT but may be anything which responds to +puts+.
  class Observer
    
    # Log object. Must respond to +puts+.
    attr_accessor :log
    
    # Creates a new Observer object
    def initialize(log=$stdout)
      @log = log
    end
    
    # Called by the Observable module through Webcrawler. 
    def update(response, url)
      @log.puts "Scanning: " + url.to_s
      if response.kind_of?(Net::HTTPClientError) or response.kind_of?(Net::HTTPServerError)
        @log.puts "#{response.code} encountered for " + url.to_s
      end
    end
  end
end