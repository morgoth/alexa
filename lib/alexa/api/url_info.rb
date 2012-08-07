module Alexa::API
  class UrlInfo
    include Alexa::Utils

    DEFAULT_RESPONSE_GROUP = "Rank,ContactInfo,AdultContent,Speed,Language,Keywords,OwnedDomains,LinksInCount,SiteData,RelatedLinks,RankByCountry,RankByCity,UsageStats"

    attr_reader :client, :host, :response_group, :response_body

    def initialize(client)
      @client = client
    end

    def fetch(arguments = {})
      @host           = arguments[:host] || raise(ArgumentError.new("You must specify host"))
      @response_group = arguments.fetch(:response_group, DEFAULT_RESPONSE_GROUP)
      @response_body  = encode(request.body)
      self
    end

    # attributes

    def rank
      return @rank if defined?(@rank)
      if rank = safe_retrieve(parsed_body, "UrlInfoResponse", "Response", "UrlInfoResult", "Alexa", "TrafficData", "Rank")
        @rank = rank.to_i
      end
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
      if links_in_count = safe_retrieve(parsed_body, "UrlInfoResponse", "Response", "UrlInfoResult", "Alexa", "ContentData", "LinksInCount")
        @links_in_count = links_in_count.to_i
      end
    end

    def keywords
      @keywords ||= safe_retrieve(parsed_body, "UrlInfoResponse", "Response", "UrlInfoResult", "Alexa", "ContentData", "Keywords", "Keyword")
    end

    def speed_median_load_time
      return @speed_median_load_time if defined?(@speed_median_load_time)
      if speed_median_load_time = safe_retrieve(parsed_body, "UrlInfoResponse", "Response", "UrlInfoResult", "Alexa", "ContentData", "Speed", "MedianLoadTime")
        @speed_median_load_time = speed_median_load_time.to_i
      end
    end

    def speed_percentile
      return @speed_percentile if defined?(@speed_percentile)
      if speed_percentile = safe_retrieve(parsed_body, "UrlInfoResponse", "Response", "UrlInfoResult", "Alexa", "ContentData", "Speed", "Percentile")
        @speed_percentile = speed_percentile.to_i
      end
    end

    def related_links
      @related_links ||= safe_retrieve(parsed_body, "UrlInfoResponse", "Response", "UrlInfoResult", "Alexa", "Related", "RelatedLinks", "RelatedLink")
    end

    private

    def request
      handle_response Net::HTTP.get_response(url)
    end

    def parsed_body
      @parsed_body ||= MultiXml.parse(response_body)
    end

    def timestamp
      @timestamp ||= Time::now.utc.strftime("%Y-%m-%dT%H:%M:%S.000Z")
    end

    def encode(string)
      if "muflon".respond_to?(:force_encoding)
        string.force_encoding(Encoding::UTF_8)
      else
        string
      end
    end

    def handle_response(response)
      case response.code.to_i
      when 200...300
        response
      when 300...600
        if response.body.nil?
          raise StandardError.new(response)
        else
          xml = MultiXml.parse(response.body)
          message = xml["Response"]["Errors"]["Error"]["Message"]
          raise StandardError.new(message)
        end
      else
        raise StandardError.new("Unknown code: #{respnse.code}")
      end
    end

    def signature
      Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new("sha1"), client.secret_access_key, sign)).strip
    end

    def url
      URI.parse("http://#{Alexa::API_HOST}/?" + query + "&Signature=" + CGI::escape(signature))
    end

    def params_without_signature
      {
        "Action"           => "UrlInfo",
        "AWSAccessKeyId"   => client.access_key_id,
        "ResponseGroup"    => response_group,
        "SignatureMethod"  => "HmacSHA1",
        "SignatureVersion" => "2",
        "Timestamp"        => timestamp,
        "Url"              => host,
        "Version"          => Alexa::API_VERSION
      }
    end

    def sign
      "GET\n" + Alexa::API_HOST + "\n/\n" + query
    end

    def query
      params_without_signature.map { |key, value| "#{key}=#{CGI::escape(value)}" }.sort.join("&")
    end
  end
end
