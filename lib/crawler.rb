$:.unshift File.dirname(__FILE__)

require 'rubygems'
require 'net/http'
require 'nokogiri'
require 'set'

require 'crawler/page'
require 'crawler/page_processer'
require 'crawler/web_crawler'