module Alexa::API
  class TrafficHistory
    include Alexa::Utils

    attr_reader :url, :range, :start, :response_body

    def initialize(credentials)
      @credentials = credentials
    end

    def fetch(arguments = {})
      @url           = arguments[:url] || raise(ArgumentError.new("You must specify url"))
      @range         = arguments.fetch(:range, 31)
      @start         = arguments.fetch(:start) { Time.now - (3600 * 24 * range.to_i) }
      @response_body = Alexa::Connection.new(@credentials).get(params)
      self
    end

    # Attributes

    def data
      @data ||= safe_retrieve(parsed_body, "TrafficHistoryResponse", "Response", "TrafficHistoryResult", "Alexa", "TrafficHistory", "HistoricalData", "Data")
    end

    private

    def params
      {
        "Action"        => "TrafficHistory",
        "ResponseGroup" => "History",
        "Range"         => range,
        "Start"         => start_param,
        "Url"           => url
      }
    end

    def start_param
      start.respond_to?(:strftime) ? start.strftime("%Y%m%d") : start
    end

    def parsed_body
      @parsed_body ||= MultiXml.parse(response_body)
    end
  end
end
