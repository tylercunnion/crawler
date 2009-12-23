$:.unshift File.dirname(__FILE__)

require 'net/http'
require 'nokogiri'
require 'set'

require 'crawler/page'
require 'crawler/page_processor'
require 'crawler/web_crawler'