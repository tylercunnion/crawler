module Crawler
  class Page
  
    attr_accessor :html
    attr_accessor :url
  
    include Comparable
  
    def <=>(anOther)
      @url.to_s <=> anOther.url.to_s
    end
  
    def hash
      @url.hash
    end
  
    def eql?(anOther)
      self == anOther
    end
  
    def ==(anOther)
      self.url == anOther.url
    end
  
    def neighbors
      if @neighbors.nil?
        @html = Nokogiri::HTML::Document.parse(Net::HTTP.get(@url))
        @neighbors = Set.new []
        @html.search("a").each do |a_tag|
          begin
            # Remove white space and query strings from URLs. With query string
            # attached we might never stop
            link = @url + a_tag.attribute("href").to_s.strip.split('?')[0]
            link.fragment = nil
          
            @neighbors << Page.new(link) unless link.nil? || link.host != @url.host || link.path == "/" || link.path.index("javascript:") != nil
          rescue
          end
         end 
      end
      return @neighbors
    end
    
    def initialize(url)
      @url = url
    end
  
    def to_s
      return "#<Page:#{self.object_id} @url=#{@url}>"
    end

  end
end