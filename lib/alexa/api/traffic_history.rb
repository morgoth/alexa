require "alexa/api/base"

module Alexa
  module API
    class TrafficHistory < Base
      def fetch(arguments = {})
        raise ArgumentError, "You must specify url" unless arguments.has_key?(:url)
        @arguments = arguments

        @arguments[:range] = arguments.fetch(:range, 31)
        @arguments[:start] = arguments.fetch(:start) { Time.now - (3600 * 24 * @arguments[:range].to_i) }

        @response_body = Alexa::Connection.new(@credentials).get(params)
        self
      end

      # Response attributes

      def site
        @site ||= safe_retrieve(parsed_body, "TrafficHistoryResponse", "Response", "TrafficHistoryResult", "Alexa", "TrafficHistory", "Site")
      end

      def start
        @start ||= safe_retrieve(parsed_body, "TrafficHistoryResponse", "Response", "TrafficHistoryResult", "Alexa", "TrafficHistory", "Start")
      end

      def range
        return @range if defined?(@range)
        if range = safe_retrieve(parsed_body, "TrafficHistoryResponse", "Response", "TrafficHistoryResult", "Alexa", "TrafficHistory", "Range")
          @range = range.to_i
        end
      end

      def data
        @data ||= safe_retrieve(parsed_body, "TrafficHistoryResponse", "Response", "TrafficHistoryResult", "Alexa", "TrafficHistory", "HistoricalData", "Data")
      end

      def status_code
        safe_retrieve(parsed_body, "TrafficHistoryResponse", "Response", "ResponseStatus", "StatusCode")
      end

      private

      def params
        {
          "Action"        => "TrafficHistory",
          "ResponseGroup" => "History",
          "Range"         => arguments[:range],
          "Start"         => start_param,
          "Url"           => arguments[:url]
        }
      end

      def start_param
        arguments[:start].respond_to?(:strftime) ? arguments[:start].strftime("%Y%m%d") : arguments[:start]
      end
    end
  end
end
