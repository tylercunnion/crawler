class WebCrawler
  
  require 'net/http'
  require 'rubygems'
  require 'nokogiri'
  require 'set'
  require 'PageProcessor'

  attr_accessor :visited
  attr_reader :options
  
  def initialize(options={})
    @options = options
    @visited = Set.new []
  end
  
end

class DepthFirstCrawler < WebCrawler
  
  def search(url)
    @visited << url
    
    processor = PageProcessor.new url, @options
    
    neighbors = processor.process - @visited
    
    #puts "VISITED: " + @visited.length.to_s + " LINKS: " + neighbors.length.to_s
        
    # Have to check @visited again since it may/will have changed deeper in the
    # recursion
    neighbors.each { |link| search(link) unless @visited.include?(link) }
  end
  
end

class BreadthFirstCrawler < WebCrawler
    
  attr_accessor :open
  
  def initialize(options={})
    @open = Array.new
    super
  end

  def search(url)
    @open << url
    
    until @open.empty? do
      
      #puts "OPEN: " + @open.length.to_s + " CLOSED: " + @visited.length.to_s + " VISITING: " + url.to_s
      url  = @open.shift
      
      processor = PageProcessor.new url, @options
      neighbors = processor.process - @visited
      
      @open = (@open + neighbors.to_a).uniq
      
      @visited << url
    
    end
    
  end
  
end


