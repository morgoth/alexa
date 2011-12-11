require "bundler/setup"

require "minitest/autorun"
require "fakeweb"
require "mocha"

require "alexa"

if ENV["XML_PARSER"]
  require ENV["XML_PARSER"] if ["nokogiri", "libxml", "ox"].include?(ENV["XML_PARSER"])
  MultiXml.parser = ENV["XML_PARSER"]
end

class MiniTest::Unit::TestCase
  def setup
    FakeWeb.allow_net_connect = false
  end

  # Recording response is as simple as writing in terminal:
  # curl -is "http://awis.amazonaws.com/?Action=UrlInfo&AWSAccessKeyId=fake" -X GET > response.txt
  def fixture(filename)
    File.read(File.join("test", "fixtures", filename))
  end
end
