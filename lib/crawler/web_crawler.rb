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
        #puts "OPEN: " + @open.length.to_s + " CLOSED: " + @visited.length.to_s + " VISITING: " + this_obj.to_s
        neighbors = this_obj.neighbors - @visited
        @open = (@open + neighbors.to_a).uniq
        @visited << this_obj          
      end    
    end
  
  end
end