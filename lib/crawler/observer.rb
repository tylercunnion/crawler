module Crawler
  class Observer
    
    def initialize(log=$stdout)
      @log = log
    end
    
    def update(errcode, url)
      if errcode =~ /[4,5]\d\d/
        @log.puts "#{errcode} encountered for " + url
      end
    end
  end
end