require File.join(File.dirname(__FILE__), "..", "spec_helper.rb")
require 'stringio'

module Crawler
  describe Observer do
    
    def test_code(code, log, obs)
      log.should_receive(:puts).with("#{code} encountered for http://example.com/")
      obs.update("#{code}", "http://example.com/")
    end
    
    it "should output a warning when an error code is reached" do
      log = double('log')
      obs = Observer.new(log)
      (400..416).each { |code| test_code(code, log, obs) }
      (500..505).each { |code| test_code(code, log, obs) }
    end
    
    it "should not output a warning when 200 is encountered" do
      log = double('log')
      obs = Observer.new(log)
      log.should_not_receive(:puts)
      obs.update("200", "http://example.com/")
    end

  end
end