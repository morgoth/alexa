require "bundler/setup"

require "ruby-debug"
require "minitest/autorun"
require "fakeweb"
require "mocha"

require "alexa"

if ENV["xml_parser"]
  require ENV["xml_parser"] if ["nokogiri", "libxml", "ox"].include?(ENV["xml_parser"])
  MultiXml.parser = ENV["xml_parser"]
end

class MiniTest::Unit::TestCase
  def setup
    FakeWeb.allow_net_connect = false
  end

  def fixture_xml(filename)
    file_path = File.expand_path(File.dirname(__FILE__) + '/fixtures/' + filename)
    File.read(file_path)
  end

  # Recording response is as simple as writing in terminal:
  # curl -is "http://awis.amazonaws.com/?Action=UrlInfo&AWSAccessKeyId=fake" -X GET > response.txt
  def fixture(filename)
    File.read(File.join("test", "fixtures", filename))
  end
end
