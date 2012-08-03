module Alexa
  class Client
    attr_reader :access_key_id, :secret_access_key

    def initialize(configuration = {})
      @access_key_id     = configuration[:access_key_id]     || raise(ArgumentError.new("You must specify access_key_id"))
      @secret_access_key = configuration[:secret_access_key] || raise(ArgumentError.new("You must specify secret_access_key"))
    end

    def url_info(options)
      url_info = Alexa::UrlInfo.new(options)
      xml = url_info.connect
      url_info.parse_xml(xml)
      url_info
    end
  end
end
