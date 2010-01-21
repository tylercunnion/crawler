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
      
      context "during a crawl" do

        it "should sent notifications" do
          crawler = Webcrawler.new
          obs = mock("observer", :update => "Thank")
          
          crawler.add_observer(obs)
          
          uri = URI.parse('http://example.com/')

          obs.should_receive(:update)

          crawler.crawl(uri)

        end

      end
        
    end
  end
end