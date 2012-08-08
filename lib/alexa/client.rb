module Alexa
  class Client
    attr_reader :access_key_id, :secret_access_key

    def initialize(configuration = {})
      @access_key_id     = configuration[:access_key_id]     || raise(ArgumentError.new("You must specify access_key_id"))
      @secret_access_key = configuration[:secret_access_key] || raise(ArgumentError.new("You must specify secret_access_key"))
    end

    def url_info(arguments = {})
      API::UrlInfo.new(:access_key_id => access_key_id, :secret_access_key => secret_access_key).fetch(arguments)
    end

    def sites_linking_in(arguments = {})
      API::SitesLinkingIn.new(:access_key_id => access_key_id, :secret_access_key => secret_access_key).fetch(arguments)
    end

    def traffic_history(arguments = {})
      API::TrafficHistory.new(:access_key_id => access_key_id, :secret_access_key => secret_access_key).fetch(arguments)
    end
  end
end
