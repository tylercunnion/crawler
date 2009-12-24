module Crawler
  
  # Represents one HTML page. The actual page itself is lazy loaded; the page
  # is not downloaded until the html method is called.
  class Page
      
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
    
    # Returns the page in Nokogiri parsed form
    def html
      @html = Nokogiri::HTML::Document.parse(Net::HTTP.get(@url)) if @html.nil?
      return @html
    end
  
    # Get every "neighbor" of the page - that is, a Page object for everything
    # linked to from this page.
    def neighbors
      if @neighbors.nil?
        @neighbors = Set.new []
        html.search("a").each do |a_tag|    
          href = a_tag.attribute("href").to_s.strip
          begin
            link = @url + href
          rescue
            # Log the error and move on
          end
          link.normalize!
          #link.fragment = nil
          #link.query = nil
          @neighbors << Page.new(link) if link.class == URI::HTTP
        end
      end
      return @neighbors
    end
    
    def initialize(url)
      raise ArgumentError, "Given URI is not of class URI::HTTP" unless url.class == URI::HTTP
      @url = url
    end
  
    def to_s
      return "#<Page:#{self.object_id} @url=#{@url}>"
    end

  end
end