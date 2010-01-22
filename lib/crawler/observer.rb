module Crawler
  class Observer
    
    def initialize(log=$stdout)
      @log = log
    end
    
    def update(errcode, url)
      if errcode == "404"
        @log.puts "404 encountered for " + url
      end
    end
  end
end