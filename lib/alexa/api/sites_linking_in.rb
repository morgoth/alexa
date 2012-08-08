module Alexa::API
  class SitesLinkingIn
    include Alexa::Utils

    attr_reader :url, :count, :start, :response_body

    def initialize(credentials)
      @credentials = credentials
    end

    def fetch(arguments = {})
      @url           = arguments[:url] || raise(ArgumentError.new("You must specify url"))
      @count         = arguments.fetch(:count, 20)
      @start         = arguments.fetch(:start, 0)
      @response_body = Alexa::Connection.new(@credentials).get(params)
      self
    end

    # Attributes

    def sites
      @sites ||= safe_retrieve(parsed_body, "SitesLinkingInResponse", "Response", "SitesLinkingInResult", "Alexa", "SitesLinkingIn", "Site")
    end

    private

    def params
      {
        "Action"        => "SitesLinkingIn",
        "ResponseGroup" => "SitesLinkingIn",
        "Count"         => count,
        "Start"         => start,
        "Url"           => url
      }
    end

    def parsed_body
      @parsed_body ||= MultiXml.parse(response_body)
    end
  end
end
