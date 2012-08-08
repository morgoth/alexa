require "multi_xml"

require "alexa/version"
require "alexa/utils"
require "alexa/exceptions"
require "alexa/connection"
require "alexa/client"
require "alexa/api/category_browse"
require "alexa/api/category_listings"
require "alexa/api/sites_linking_in"
require "alexa/api/traffic_history"
require "alexa/api/url_info"

module Alexa
  API_VERSION = "2005-07-11"
  API_HOST    = "awis.amazonaws.com"
end
