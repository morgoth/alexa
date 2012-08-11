module Alexa::API
  class SitesLinkingIn
    include Alexa::Utils

    attr_reader :arguments, :response_body

    def initialize(credentials)
      @credentials = credentials
    end

    def fetch(arguments = {})
      raise ArgumentError, "You must specify url" unless arguments.has_key?(:url)
      @arguments = arguments

      @arguments[:count] = arguments.fetch(:count, 20)
      @arguments[:start] = arguments.fetch(:start, 0)

      @response_body = Alexa::Connection.new(@credentials).get(params)
      self
    end

    def parsed_body
      @parsed_body ||= MultiXml.parse(response_body)
    end

    # Response attributes

    def sites
      @sites ||= safe_retrieve(parsed_body, "SitesLinkingInResponse", "Response", "SitesLinkingInResult", "Alexa", "SitesLinkingIn", "Site")
    end

    private

    def params
      {
        "Action"        => "SitesLinkingIn",
        "ResponseGroup" => "SitesLinkingIn",
        "Count"         => arguments[:count],
        "Start"         => arguments[:start],
        "Url"           => arguments[:url]
      }
    end
  end
end
