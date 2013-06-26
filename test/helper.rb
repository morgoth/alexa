require "minitest/autorun"
require "webmock/minitest"
require "mocha/setup"

require "alexa"

xml_parser = ENV["XML_PARSER"] || "libxml"

require xml_parser if ["nokogiri", "libxml", "ox"].include?(xml_parser)
MultiXml.parser = xml_parser

class MiniTest::Test
  def setup
    WebMock.disable_net_connect!
  end

  # Recording response is as simple as writing in terminal:
  # curl -is -X GET "http://awis.amazonaws.com/?Action=UrlInfo&AWSAccessKeyId=fake" > response.txt
  def fixture(filename)
    File.read(File.join("test", "fixtures", filename))
  end
end
