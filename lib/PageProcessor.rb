class PageProcessor
  require 'net/http'
  require 'rubygems'
  require 'nokogiri'
  require 'set'
  
  attr_accessor :page
  attr_accessor :options
  attr_accessor :url
  
  def initialize(url, options={})
    @url = url
    @options = options
    
    @page = Nokogiri::HTML::Document.parse(Net::HTTP.get(url))
      
    options[:extras].inject(self) {|memo, val| memo.extend val }
    
    
  end
  
  def process
    
    puts "VISITING: " + @url.to_s
    
    neighbors = Set.new []
    
    @page.search("a").each do |a_tag|
        begin
          # Remove white space and query strings from URLs. With query string
          # attached we might never stop
          link = @url + a_tag.attribute("href").to_s.strip.split('?')[0]
          link.fragment = nil
          
          neighbors << link unless link.nil? || link.host != url.host
        rescue
        end
    end
          
    return neighbors        
      
  end
  
end


module TagIdentifier
  def process
    neighbors = super
    @options[:tags].each do |tag|
      puts tag + " found." unless @page.search(tag).empty?
    end
        
    return neighbors
  end
end

module LinkExcluder
  def process
    neighbors = super
    @options[:exclude].each do |exclude|
      neighbors.delete_if { |link| link.path.index(exclude) != nil }
    end
    return neighbors
  end
end