require '../lib/crawler'
include Crawler

describe Page do

  it "should initialize from a URI" do
    url = URI.parse("http://example.com")
    page = Page.new(url)
    page.should be_instance_of(Page)
  end
  
  it "should not initialize with a malformed URI" do
    url = URI.parse("file://hurfdurf.html")
    lambda {page = Page.new(url)}.should raise_error
  end
  
  it "should not initialize with anything other than a URI" do
    lambda {page = Page.new(5)}.should raise_error
  end
  
  it "should equal a Page with the same URI" do
    url = URI.parse("http://example.com")
    page1 = Page.new(url)
    page2 = Page.new(url)
    
    page1.should eql(page2)
  end
  
  it "should not equal a Page with a different URI" do
    url1 = URI.parse("http://example.com/a")
    url2 = URI.parse("http://example.com/b")
    
    page1 = Page.new(url1)
    page2 = Page.new(url2)
    
    page1.should_not eql(page2)
  end
  
  it "should compare according to the URI" do
    url1 = URI.parse("http://example.com/a")
    url2 = URI.parse("http://example.com/b")
    
    page1 = Page.new(url1)
    page2 = Page.new(url2)
    
    page1.should satisfy { |p| p < page2 }
  end

end
