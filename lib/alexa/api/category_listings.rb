require "alexa/api/base"

module Alexa
  module API
    class CategoryListings < Base
      def fetch(arguments = {})
        raise ArgumentError, "You must specify path" unless arguments.has_key?(:path)
        @arguments = arguments

        @arguments[:sort_by]      = arguments.fetch(:sort_by, "popularity")
        @arguments[:recursive]    = arguments.fetch(:recursive, true)
        @arguments[:descriptions] = arguments.fetch(:descriptions, true)
        @arguments[:start]        = arguments.fetch(:start, 0)
        @arguments[:count]        = arguments.fetch(:count, 20)

        @response_body = Alexa::Connection.new(@credentials).get(params)
        self
      end

      # Response attributes

      def count
        return @count if defined?(@count)
        if count = safe_retrieve(parsed_body, "CategoryListingsResponse", "Response", "CategoryListingsResult", "Alexa", "CategoryListings", "Count")
          @count = count.to_i
        end
      end

      def recursive_count
        return @recursive_count if defined?(@recursive_count)
        if recursive_count = safe_retrieve(parsed_body, "CategoryListingsResponse", "Response", "CategoryListingsResult", "Alexa", "CategoryListings", "RecursiveCount")
          @recursive_count = recursive_count.to_i
        end
      end

      def listings
        @listings ||= safe_retrieve(parsed_body, "CategoryListingsResponse", "Response", "CategoryListingsResult", "Alexa", "CategoryListings", "Listings", "Listing")
      end

      def status_code
        safe_retrieve(parsed_body, "CategoryListingsResponse", "Response", "ResponseStatus", "StatusCode")
      end

      private

      def params
        {
          "Action"        => "CategoryListings",
          "ResponseGroup" => "Listings",
          "Path"          => arguments[:path],
          "Recursive"     => recursive_param,
          "Descriptions"  => descriptions_param,
          "SortBy"        => sort_by_param,
          "Count"         => arguments[:count],
          "Start"         => arguments[:start],
        }
      end

      def recursive_param
        arguments[:recursive].to_s.capitalize
      end

      def descriptions_param
        arguments[:descriptions].to_s.capitalize
      end

      def sort_by_param
        camelize(arguments[:sort_by])
      end
    end
  end
end
