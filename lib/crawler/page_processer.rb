module Crawler
  # Class which processes HTML pages. The class may be initialized with one or
  # more 'extras', decorators which provide additional processing beyond simply
  # finding neighbors.

  class PageProcessor
    attr_accessor :page
    attr_accessor :options
    attr_reader :url

    def url=(url)
      @url = url
      @page = Nokogiri::HTML::Document.parse(Net::HTTP.get(url))
    end
  
    def initialize(url, options={})
      @url = url
      @options = options
    
      @page = Nokogiri::HTML::Document.parse(Net::HTTP.get(url))
      
      options[:extras].inject(self) {|memo, val| memo.extend val }
    
    
    end
  
    # Process the page. The base method finds neighbors and returns a Set of
    # them. Optional decorators may have further effects.
  
    def process
    
      puts "VISITING: " + @url.to_s
    
      neighbors = Set.new []
    
      @page.search("a").each do |a_tag|
          begin
            # Remove white space and query strings from URLs. With query string
            # attached we might never stop
            link = @url + a_tag.attribute("href").to_s.strip.split('?')[0]
            link.fragment = nil

          
            neighbors << link unless link.nil? || link.host != url.host || link.path == "/"
          rescue
          end
      end
          
      return neighbors        
      
    end
  
  end


  module TagIdentifier

    # Finds any instances of the tags provided in the options.

    def process
      neighbors = super
      @options[:tags].each do |tag|
        puts tag + " found." unless @page.search(tag).empty?
      end
        
      return neighbors
    end
  end

  # Adds ability to ignore certain links based on the content of their path. For
  # instance, you can ignore .pdf files

  module LinkExcluder
    def process
      neighbors = super
      @options[:exclude].each do |exclude|
        neighbors.delete_if { |link| link.path.index(exclude) != nil }
      end
      return neighbors
    end
  end

  module GraphGenerator

#  	require 'rubygems'
  	require 'rgl/dot'

  	attr_accessor :graph


  	def graph_string
  		@graph.to_s
  	end

  
    def process
      neighbors = super

      @graph = RGL::DOT::Digraph.new if @graph.nil?



      curr_node = RGL::DOT::Node.new
      curr_node.name = @url.path.to_s

      neighbors.each do |link|
        node = RGL::DOT::Node.new
        node.name = link.path.to_s
        edge = RGL::DOT::DirectedEdge.new
        edge.from = curr_node
        edge.to = node
        @graph << edge
      end

      return neighbors
    end
  end
end