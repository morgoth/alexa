$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "alexa"

require "minitest/autorun"
require "mocha/setup"
require "vcr"

xml_parser = ENV["XML_PARSER"] || "libxml"

require xml_parser if ["nokogiri", "libxml", "ox"].include?(xml_parser)
MultiXml.parser = xml_parser

ACCESS_KEY_ID = ENV["ACCESS_KEY_ID"] || "access-key-id"
SECRET_ACCESS_KEY = ENV["SECRET_ACCESS_KEY"] || "secret-access-key"

VCR.configure do |config|
  config.cassette_library_dir = "test/cassettes"
  config.hook_into :webmock
  config.default_cassette_options = {record: :once}
  config.filter_sensitive_data("<FILTERED>") { ACCESS_KEY_ID }
  config.filter_sensitive_data("<FILTERED>") { SECRET_ACCESS_KEY }
end
