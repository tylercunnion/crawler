module Crawler
  class Observer
    
    def initialize(log=$stdout)
      @log = log
    end
    
    def update(response, url)
      puts "Received message for " + url.to_s
      if response.kind_of?(Net::HTTPClientError) or response.kind_of?(Net::HTTPServerError)
        @log.puts "#{response.code} encountered for " + url.to_s
      end
    end
  end
end