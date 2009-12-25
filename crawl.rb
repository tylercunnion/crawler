#! /usr/bin/ruby

require 'lib/crawler'
require 'optparse'
require 'set'
require 'mixology'
    
options = {}
options[:extras] = []

crawler = Crawler::WebCrawler.new(options)

optionparser = OptionParser.new do |opts|
  opts.on("-t", "--tag a,b,c", Array,
    "Report incidences of the given tag(s)") do |tags|
      crawler.mixin Crawler::TagIdentifyCrawler
      crawler.tags = tags.to_set
    end
    
  #opts.on("-x", "--exclude .pdf, conted", Array,
  #  "Ignore URLs containing the given string(s)") do |exclude|
  #    options[:exclude] = exclude.to_set
  #    options[:extras] << LinkExcluder
  #  end
  
  opts.on("-v", "--verbose", "Verbose mode") do
    crawler.mixin Crawler::VerboseCrawler
  end
    
  opts.parse!(ARGV)
end

url_string = ARGV[0]
begin
  url = URI.parse(url_string)
  raise if url.class != URI::HTTP
rescue
  puts "Error parsing URL: #{url_string}"
  Process.exit
end

url.normalize!

crawler.search(Crawler::Page.new(url))
    
puts crawler.visited.collect { |link| link.to_s }.sort
