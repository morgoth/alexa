require "alexa/api/base"

module Alexa
  module API
    class SitesLinkingIn < Base
      def fetch(arguments = {})
        raise ArgumentError, "You must specify url" unless arguments.has_key?(:url)
        @arguments = arguments

        @arguments[:count] = arguments.fetch(:count, 20)
        @arguments[:start] = arguments.fetch(:start, 0)

        @response_body = Alexa::Connection.new(@credentials).get(params)
        self
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
end
