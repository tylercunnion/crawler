module Crawler
  class WebCrawler

    require 'pp'

    attr_accessor :visited
    attr_reader :options
  
    def initialize(options={})
      @options = options
      @visited = Set.new []
    end
  
  end

  class DepthFirstCrawler < WebCrawler
  
    def search(obj)
      @visited << obj
    
      neighbors = obj.neighbors - @visited
         
      # Have to check @visited again since it may/will have changed deeper in the
      # recursion
      neighbors.each { |neighbor| search(neighbor) unless @visited.include?(neighbor) }
    end
  
  end

  class BreadthFirstCrawler < WebCrawler
    
    attr_accessor :open
  
    def initialize(options={})
      @open = Array.new
      super
    end

    def search(obj)
    
      @open << obj
      until @open.empty? do
      
        this_obj = @open.shift
        #puts "OPEN: " + @open.length.to_s + " CLOSED: " + @visited.length.to_s + " VISITING: " + this_obj.to_s
        neighbors = this_obj.neighbors - @visited
        @open = (@open + neighbors.to_a).uniq
        @visited << this_obj          
      end    
    end
  
  end
end