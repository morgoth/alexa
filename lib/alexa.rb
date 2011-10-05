require "cgi"
require "base64"
require "openssl"
require "digest/sha1"
require "uri"
require "net/https"
require "time"

require "multi_xml"

require "alexa/config"
require "alexa/url_info"
require "alexa/version"

module Alexa
  def self.url_info(options = {})
    url_info = Alexa::UrlInfo.new(options)
    xml = url_info.connect
    url_info.parse_xml(xml)
    url_info
  end
end
