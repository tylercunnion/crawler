module Crawler
  # Implementation of the breadth-first search algorithm.
  class WebCrawler

    require 'pp'

    attr_accessor :visited
    attr_reader :options
    attr_accessor :open
    
  
    def initialize(options={})
      @options = options
      @visited = Set.new []
      @open = Array.new
    end    

    def search(obj)
      @open << obj
      until @open.empty? do
        this_obj = @open.shift
        before_get_neighbors(this_obj)
        neighbors = this_obj.neighbors - @visited
        neighbors = process_neighbors(neighbors)
        @open = (@open + neighbors.to_a).uniq
        @visited << this_obj
      end    
    end
    
    # Operates on the list of neighbors. For extensions, remember to always return
    # +neighbors+ again.
    def process_neighbors(neighbors)
      return neighbors
    end
    
    # Run before neighbors are retrieved. Mostly for decorators to hook onto.
    # - obj: The object currently being operated on by the crawler
    def before_get_neighbors(obj)
      puts "OPEN: " + @open.length.to_s + " CLOSED: " + @visited.length.to_s + " VISITING: " + obj.to_s
    end
  
  end
end
