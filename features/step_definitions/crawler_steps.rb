Given /^the crawl has not begun$/ do
end

When /^I start a crawl with the URI "([^\"]*)"$/ do |arg1|
  @obs = Crawler::Observer.new
  @crawler = Crawler::Webcrawler.new
  
  @crawler.add_observer(@obs)
  
  @uri = URI.parse(arg1)
  @crawler.crawl(@uri)
end

Then /^the page should be downloaded$/ do
  @crawler.crawled.should include(@uri)
end

Then /^the observer should be updated$/ do
  @obs.should_receive(:update)
end