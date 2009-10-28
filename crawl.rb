#! /usr/bin/ruby

$LOAD_PATH << "./lib"

require 'WebCrawler'
require 'optparse'
require 'set'
    
options = {}
options[:extras] = []

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



#crawler = BreadthFirstCrawler.new(options)
crawler = DepthFirstCrawler.new(options)

url = ARGV[0]
begin
  url = URI.parse(url)
  raise Exception if url.class != URI::HTTP
rescue
  puts "Error parsing URL"
  Process.exit
end

url.normalize!

crawler.search(url)
    
puts crawler.visited.collect { |link| link.to_s }.sort
