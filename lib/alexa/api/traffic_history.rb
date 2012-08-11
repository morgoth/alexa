module Alexa::API
  class TrafficHistory
    include Alexa::Utils

    attr_reader :arguments, :response_body

    def initialize(credentials)
      @credentials = credentials
    end

    def fetch(arguments = {})
      raise ArgumentError, "You must specify url" unless arguments.has_key?(:url)
      @arguments = arguments

      @arguments[:range] = arguments.fetch(:range, 31)
      @arguments[:start] = arguments.fetch(:start) { Time.now - (3600 * 24 * @arguments[:range].to_i) }

      @response_body = Alexa::Connection.new(@credentials).get(params)
      self
    end

    def parsed_body
      @parsed_body ||= MultiXml.parse(response_body)
    end

    # Response attributes

    def data
      @data ||= safe_retrieve(parsed_body, "TrafficHistoryResponse", "Response", "TrafficHistoryResult", "Alexa", "TrafficHistory", "HistoricalData", "Data")
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
