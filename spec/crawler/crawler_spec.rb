require File.join(File.dirname(__FILE__), "..", "spec_helper.rb")

module Crawler
  describe Webcrawler do
   
    context "before crawl" do
      it "should have an empty crawl list" do
        crawler = Webcrawler.new
        crawler.crawled.should be_empty
      end
    end
    
    context "after crawl" do
      before(:each) do
        @crawler = Webcrawler.new
        @uri = URI.parse('http://example.com/')
        @crawler.crawl(@uri)
      end
      
      it "should have at least one item in crawled" do
        @crawler.crawled.should_not be_empty
      end
      
        
    end
  end
end