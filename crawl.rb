#! /usr/bin/ruby

require 'lib/crawler'
require 'optparse'
require 'set'
    
options = {}
options[:extras] = []

=begin
optionparser = OptionParser.new do |opts|
  opts.on("-t", "--tag a,b,c", Array,
    "Report incidences of the given tag(s)") do |tags|
      options[:tags] = tags.to_set
      options[:extras] << TagIdentifier
    end
    
  opts.on("-x", "--exclude .pdf, conted", Array,
    "Ignore URLs containing the given string(s)") do |exclude|
      options[:exclude] = exclude.to_set
      options[:extras] << LinkExcluder
    end
    
  opts.parse!(ARGV)
end

options[:extras] << GraphGenerator

=end

crawler = Crawler::BreadthFirstCrawler.new(options)
#crawler = DepthFirstCrawler.new(options)

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
