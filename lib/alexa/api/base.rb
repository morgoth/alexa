module Alexa
  module API
    class Base
      include Utils

      attr_reader :arguments, :response_body

      def initialize(credentials)
        if MultiXml.parser.to_s == "MultiXml::Parsers::Ox"
          raise StandardError, "MultiXml parser is set to :ox - alexa gem will not work with it currently, use one of: :libxml, :nokogiri, :rexml"
        end
        @credentials = credentials
      end

      def parsed_body
        @parsed_body ||= MultiXml.parse(response_body)
      end
    end
  end
end
