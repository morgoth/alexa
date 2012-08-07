require "cgi"
require "base64"
require "openssl"
require "digest/sha1"
require "net/https"
require "time"

require "multi_xml"

require "alexa/version"
require "alexa/utils"
require "alexa/client"
require "alexa/api/url_info"

module Alexa
  API_VERSION = "2005-07-11"
  API_HOST = "awis.amazonaws.com"
end
