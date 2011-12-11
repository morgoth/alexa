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
  class << self
    attr_accessor :access_key_id, :secret_access_key

    def configure
      yield self
    end

    def url_info(options = {})
      url_info = Alexa::UrlInfo.new(options)
      xml = url_info.connect
      url_info.parse_xml(xml)
      url_info
    end
  end
end
