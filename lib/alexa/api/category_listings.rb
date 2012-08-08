module Alexa::API
  class CategoryListings
    include Alexa::Utils

    attr_reader :path, :sort_by, :recursive, :start, :count, :descriptions, :response_body

    def initialize(credentials)
      @credentials = credentials
    end

    def fetch(arguments = {})
      @path          = arguments[:path] || raise(ArgumentError.new("You must specify path"))
      @sort_by       = arguments.fetch(:sort_by, "popularity")
      @recursive     = arguments.fetch(:recursive, true)
      @start         = arguments.fetch(:start, 0)
      @count         = arguments.fetch(:count, 20)
      @descriptions  = arguments.fetch(:descriptions, true)
      @response_body = Alexa::Connection.new(@credentials).get(params)
      self
    end

    # Attributes

    def recursive_count
      return @recursive_count if defined?(@recursive_count)
      if recursive_count = safe_retrieve(parsed_body, "CategoryListingsResponse", "Response", "CategoryListingsResult", "Alexa", "CategoryListings", "RecursiveCount")
        @recursive_count = recursive_count.to_i
      end
    end

    def listings
      @listings ||= safe_retrieve(parsed_body, "CategoryListingsResponse", "Response", "CategoryListingsResult", "Alexa", "CategoryListings", "Listings", "Listing")
    end

    private

    def params
      {
        "Action"        => "CategoryListings",
        "ResponseGroup" => "Listings",
        "Path"          => path,
        "Recursive"     => recursive_param,
        "Descriptions"  => descriptions_param,
        "SortBy"        => sort_by_param,
        "Count"         => count,
        "Start"         => start,
      }
    end

    def recursive_param
      recursive.to_s.capitalize
    end

    def descriptions_param
      descriptions.to_s.capitalize
    end

    def sort_by_param
      camelize(sort_by)
    end

    def parsed_body
      @parsed_body ||= MultiXml.parse(response_body)
    end
  end
end
