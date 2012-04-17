require "bundler/setup"

require "minitest/autorun"
require "fakeweb"
require "mocha"

require "alexa"

alexa_xml_parser = ENV["ALEXA_XML_PARSER"] || "rexml"

require alexa_xml_parser if ["nokogiri", "libxml", "ox"].include?(alexa_xml_parser)
MultiXml.parser = alexa_xml_parser

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
