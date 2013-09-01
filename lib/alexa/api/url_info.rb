require "alexa/api/base"

module Alexa
  module API
    class UrlInfo < Base
      DEFAULT_RESPONSE_GROUP = ["adult_content", "contact_info", "keywords", "language", "links_in_count", "owned_domains", "rank", "rank_by_city", "rank_by_country", "related_links", "site_data", "speed", "usage_stats", "categories"]

      def fetch(arguments = {})
        raise ArgumentError, "You must specify url" unless arguments.has_key?(:url)
        @arguments = arguments

        @arguments[:response_group] = Array(arguments.fetch(:response_group, DEFAULT_RESPONSE_GROUP))

        @response_body = Alexa::Connection.new(@credentials).get(params)
        self
      end

      # Response attributes

      def rank
        return @rank if defined?(@rank)
        rank = safe_retrieve(parsed_body, "UrlInfoResponse", "Response", "UrlInfoResult", "Alexa", "TrafficData", "Rank")
        @rank = rank ? rank.to_i : nil
      end

      def rank_by_country
        @rank_by_country ||= safe_retrieve(parsed_body, "UrlInfoResponse", "Response", "UrlInfoResult", "Alexa", "TrafficData", "RankByCountry", "Country")
      end

      def rank_by_city
        @rank_by_city ||= safe_retrieve(parsed_body, "UrlInfoResponse", "Response", "UrlInfoResult", "Alexa", "TrafficData", "RankByCity", "City")
      end

      def data_url
        @data_url ||= safe_retrieve(parsed_body, "UrlInfoResponse", "Response", "UrlInfoResult", "Alexa", "TrafficData", "DataUrl", "__content__")
      end

      def usage_statistics
        @usage_statistics ||= safe_retrieve(parsed_body, "UrlInfoResponse", "Response", "UrlInfoResult", "Alexa", "TrafficData", "UsageStatistics", "UsageStatistic")
      end

      def site_title
        @site_title ||= safe_retrieve(parsed_body, "UrlInfoResponse", "Response", "UrlInfoResult", "Alexa", "ContentData", "SiteData", "Title")
      end

      def site_description
        @site_description ||= safe_retrieve(parsed_body, "UrlInfoResponse", "Response", "UrlInfoResult", "Alexa", "ContentData", "SiteData", "Description")
      end

      def language_locale
        @language_locale ||= safe_retrieve(parsed_body, "UrlInfoResponse", "Response", "UrlInfoResult", "Alexa", "ContentData", "Language", "Locale")
      end

      def language_encoding
        @language_encoding ||= safe_retrieve(parsed_body, "UrlInfoResponse", "Response", "UrlInfoResult", "Alexa", "ContentData", "Language", "Encoding")
      end

      def links_in_count
        return @links_in_count if defined?(@links_in_count)
        links_in_count = safe_retrieve(parsed_body, "UrlInfoResponse", "Response", "UrlInfoResult", "Alexa", "ContentData", "LinksInCount")
        @links_in_count = links_in_count ? links_in_count.to_i : nil
      end

      def keywords
        @keywords ||= safe_retrieve(parsed_body, "UrlInfoResponse", "Response", "UrlInfoResult", "Alexa", "ContentData", "Keywords", "Keyword")
      end

      def speed_median_load_time
        return @speed_median_load_time if defined?(@speed_median_load_time)
        speed_median_load_time = safe_retrieve(parsed_body, "UrlInfoResponse", "Response", "UrlInfoResult", "Alexa", "ContentData", "Speed", "MedianLoadTime")
        @speed_median_load_time = speed_median_load_time ? speed_median_load_time.to_i : nil
      end

      def speed_percentile
        return @speed_percentile if defined?(@speed_percentile)
        speed_percentile = safe_retrieve(parsed_body, "UrlInfoResponse", "Response", "UrlInfoResult", "Alexa", "ContentData", "Speed", "Percentile")
        @speed_percentile = speed_percentile ? speed_percentile.to_i : nil
      end

      def related_links
        @related_links ||= safe_retrieve(parsed_body, "UrlInfoResponse", "Response", "UrlInfoResult", "Alexa", "Related", "RelatedLinks", "RelatedLink")
      end

      def categories
        @categories ||= safe_retrieve(parsed_body, "UrlInfoResponse", "Response", "UrlInfoResult", "Alexa", "Related", "Categories", "CategoryData")
      end

      def status_code
        @status_code ||= safe_retrieve(parsed_body, "UrlInfoResponse", "Response", "ResponseStatus", "StatusCode")
      end

      def request_id
        @request_id ||= safe_retrieve(parsed_body, "UrlInfoResponse", "Response", "OperationRequest", "RequestId")
      end

      private

      def params
        {
          "Action"        => "UrlInfo",
          "ResponseGroup" => response_group_param,
          "Url"           => arguments[:url]
        }
      end

      def response_group_param
        arguments[:response_group].sort.map { |group| camelize(group) }.join(",")
      end
    end
  end
end
