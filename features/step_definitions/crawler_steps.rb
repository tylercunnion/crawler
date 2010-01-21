Given /^the crawl has not begun$/ do
end

When /^I start a crawl with the URI "([^\"]*)"$/ do |arg1|
  @messenger = StringIO.new
  @crawler = Crawler::Webcrawler.new(@messenger)
  @uri = URI.parse(arg1)
  @crawler.crawl(@uri)
end

Then /^the page should be downloaded$/ do
  @crawler.crawled.should include(@uri)
end