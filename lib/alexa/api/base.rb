module Alexa::API
  class Base
    include Alexa::Utils

    attr_reader :arguments, :response_body

    def initialize(credentials)
      @credentials = credentials
    end

    def parsed_body
      @parsed_body ||= MultiXml.parse(response_body)
    end
  end
end
