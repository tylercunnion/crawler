require File.join(File.dirname(__FILE__), "..", "spec_helper.rb")

module Crawler
  describe Webcrawler do
    
    before(:all) do
      @uri_base = 'http://localhost:12000/'
      www_root = File.join(File.dirname(__FILE__), '..', 'fixtures')
      @server = Thread.new do
        s = WEBrick::HTTPServer.new({:Port => 12000, :DocumentRoot => www_root, :AccessLog => []})
        @port = s.config[:Port]
        begin
          s.start
        ensure
          s.shutdown
        end
      end
    end
    
    after(:all) do
      @server.exit
    end
   
    context "before crawl" do
      it "should have an empty crawl list" do
        crawler = Webcrawler.new
        crawler.crawled.should be_empty
      end
    end
      
    context "during a crawl" do
        
        before(:each) do
          @crawler = Webcrawler.new
          @obs = mock("observer", :update => nil)
          @crawler.add_observer(@obs)
        end

        it "should send notifications" do
          uri = URI.parse(@uri_base)
          
          @obs.should_receive(:update)
          @crawler.crawl(uri)
        end
        
        it "should send status code and URL" do
          uri = URI.parse(@uri_base)
          @obs.should_receive(:update).with(kind_of(Net::HTTPResponse), uri.to_s)
          @crawler.crawl(uri)
        end
        
        it "should send 404 for missing URL" do
          uri = URI.parse(@uri_base + 'doesnotexist.html')
          @obs.should_receive(:update).with(instance_of(Net::HTTPNotFound), uri.to_s)
          @crawler.crawl(uri)
        end


      end
      
    context "after crawl" do
      before(:each) do
        @crawler = Webcrawler.new
        @uri = URI.parse(@uri_base)
        @crawler.crawl(@uri)
      end
      
      it "should have at least one item in crawled" do
        @crawler.crawled.should_not be_empty
      end
      
      it "should have put crawled links into crawled" do
        @crawler.should have(3).crawled
      end
    end
  end
end