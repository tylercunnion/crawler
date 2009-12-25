module Crawler
  module VerboseCrawler
    def before_get_neighbors(obj)
      super
      puts "OPEN: " + @open.length.to_s + " CLOSED: " + @visited.length.to_s + " VISITING: " + obj.to_s
    end
  end
  
  module TagIdentifyCrawler
    attr_accessor :tags
    attr_accessor :tag_incidences
    
    def before_get_neighbors(obj)
      super
      if @tag_incidences.nil?
        @tag_incidences = {}
        @tags.each {|tag| @tag_incidences[tag.to_sym] = []}
      end
      
      @tags.each do |tag|
        @tag_incidences[tag.to_sym] << obj
      end
    end
  end
  
end