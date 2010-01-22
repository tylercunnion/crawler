require File.join(File.dirname(__FILE__), "..", "spec_helper.rb")
require 'stringio'

module Crawler
  describe Observer do
    
    it "should output a warning when 404 is reached" do
      log = double('log')
      obs = Observer.new(log)
      log.should_receive(:puts).with("404 encountered for http://example.com/")
      obs.update("404", "http://example.com/")      
    end
    
    it "should not output a warning when 200 is encountered" do
      log = double('log')
      obs = Observer.new(log)
      log.should_not_receive(:puts)
      obs.update("200", "http://example.com/")
    end
    

  end
end