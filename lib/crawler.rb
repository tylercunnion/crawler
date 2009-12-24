$:.unshift File.dirname(__FILE__)

require 'net/http'
require 'nokogiri'
require 'set'
require 'forwardable'

require 'crawler/page'
require 'crawler/web_crawler'
require 'crawler/web_crawler_decorator'
