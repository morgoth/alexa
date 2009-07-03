module Alexa
  class UrlInfo
    RESPONSE_GROUP = "Rank,ContactInfo,AdultContent,Speed,Language,Keywords,OwnedDomains,LinksInCount,SiteData,RelatedLinks,RankByCountry,RankByCity,UsageStats"
    attr_accessor :access_key_id, :secret_access_key, :host, :response_group, :xml_response,
      :rank, :data_url, :site_title, :site_description, :language_locale, :language_encoding,
      :links_in_count, :keywords, :related_links, :speed_median_load_time, :speed_percentile,
      :rank_by_country, :rank_by_city, :usage_statistics

    def initialize(options = {} )
      @access_key_id = options[:access_key_id]
      @secret_access_key = options[:secret_access_key]
      @host = options[:host]
      @response_group = options[:response_group] || RESPONSE_GROUP
    end

    def connect
      action = "UrlInfo"
      timestamp = ( Time::now ).utc.strftime("%Y-%m-%dT%H:%M:%S.000Z")
      signature = generate_signature(secret_access_key, action, timestamp)
      url = generate_url(action, access_key_id, signature, timestamp, response_group, host)
      @xml_response = Net::HTTP.get(url)
    end

    def parse_xml(xml)
      xml = XmlSimple.xml_in(xml.force_encoding(Encoding::UTF_8), 'ForceArray' => false)
      @rank = xml['Response']['UrlInfoResult']['Alexa']['TrafficData']['Rank'].to_i
      @data_url = xml['Response']['UrlInfoResult']['Alexa']['TrafficData']['DataUrl']['content']
      @site_title = xml['Response']['UrlInfoResult']['Alexa']['ContentData']['SiteData']['Title']
      @site_description = xml['Response']['UrlInfoResult']['Alexa']['ContentData']['SiteData']['Description']
      @language_locale = xml['Response']['UrlInfoResult']['Alexa']['ContentData']['Language']['Locale']
      @language_encoding = xml['Response']['UrlInfoResult']['Alexa']['ContentData']['Language']['Encoding']
      @links_in_count = xml['Response']['UrlInfoResult']['Alexa']['ContentData']['LinksInCount'].to_i
      @keywords = xml['Response']['UrlInfoResult']['Alexa']['ContentData']['Keywords']['Keyword']
      @related_links = xml['Response']['UrlInfoResult']['Alexa']['Related']['RelatedLinks']['RelatedLink']
      @speed_median_load_time = xml['Response']['UrlInfoResult']['Alexa']['ContentData']['Speed']['MedianLoadTime'].to_i
      @speed_percentile = xml['Response']['UrlInfoResult']['Alexa']['ContentData']['Speed']['Percentile'].to_i
      @rank_by_country = xml['Response']['UrlInfoResult']['Alexa']['TrafficData']['RankByCountry']['Country']
      @rank_by_city = xml['Response']['UrlInfoResult']['Alexa']['TrafficData']['RankByCity']['City']
      @usage_statistics = xml['Response']['UrlInfoResult']['Alexa']['TrafficData']['UsageStatistics']["UsageStatistic"]
    end

    private

    def generate_signature(secret_acces_key, action, timestamp)
      Base64.encode64( OpenSSL::HMAC.digest( OpenSSL::Digest::Digest.new( "sha1" ), secret_access_key, action + timestamp)).strip
    end

    def generate_url(action, access_key_id, signature, timestamp, response_group, host)
      url = URI.parse(
          "http://awis.amazonaws.com/?" +
          {
            "Action"       => action,
            "AWSAccessKeyId"  => access_key_id,
            "Signature"       => signature,
            "Timestamp"       => timestamp,
            "ResponseGroup"   => response_group,
            "Url"           => host
          }.to_a.collect{|item| item.first + "=" + CGI::escape(item.last) }.join("&")     # Put key value pairs into http GET format
       )
    end
  end
end