module Alexa
  class UrlInfo
    API_VERSION = "2005-07-11"
    RESPONSE_GROUP = "Rank,ContactInfo,AdultContent,Speed,Language,Keywords,OwnedDomains,LinksInCount,SiteData,RelatedLinks,RankByCountry,RankByCity,UsageStats"

    attr_accessor :host, :response_group, :xml_response,
      :rank, :data_url, :site_title, :site_description, :language_locale, :language_encoding,
      :links_in_count, :keywords, :related_links, :speed_median_load_time, :speed_percentile,
      :rank_by_country, :rank_by_city, :usage_statistics

    def initialize(options = {})
      Alexa.config.access_key_id = options.fetch(:access_key_id, Alexa.config.access_key_id)
      Alexa.config.secret_access_key = options.fetch(:secret_access_key, Alexa.config.secret_access_key)
      raise ArgumentError.new("You must specify access_key_id") if Alexa.config.access_key_id.nil?
      raise ArgumentError.new("You must specify secret_access_key") if Alexa.config.secret_access_key.nil?
      self.host = options[:host] or raise ArgumentError.new("You must specify host")
      self.response_group = options.fetch(:response_group, RESPONSE_GROUP)
    end

    def connect
      response = Net::HTTP.start(url.host) do |http|
        http.get url.request_uri
      end
      self.xml_response = handle_response(response).body
    end

    def parse_xml(xml)
      xml = XmlSimple.xml_in(force_encoding(xml), 'ForceArray' => false)
      group = response_group.split(',')
      alexa = xml['Response']['UrlInfoResult']['Alexa']
      self.rank = alexa['TrafficData']['Rank'].to_i if group.include?('Rank') and !alexa['TrafficData']['Rank'].empty?
      self.data_url = alexa['TrafficData']['DataUrl']['content'] if group.include?('Rank')
      self.rank_by_country = alexa['TrafficData']['RankByCountry']['Country'] if group.include?('RankByCountry')
      self.rank_by_city = alexa['TrafficData']['RankByCity']['City'] if group.include?('RankByCity')
      self.usage_statistics = alexa['TrafficData']['UsageStatistics']["UsageStatistic"] if group.include?('UsageStats') and !alexa['TrafficData']['UsageStatistics'].nil?

      self.site_title = alexa['ContentData']['SiteData']['Title'] if group.include?('SiteData')
      self.site_description = alexa['ContentData']['SiteData']['Description'] if group.include?('SiteData')
      self.language_locale = alexa['ContentData']['Language']['Locale'] if group.include?('Language')
      self.language_encoding = alexa['ContentData']['Language']['Encoding'] if group.include?('Language')
      self.links_in_count = alexa['ContentData']['LinksInCount'].to_i if group.include?('LinksInCount') and !alexa['ContentData']['LinksInCount'].empty?
      self.keywords = alexa['ContentData']['Keywords']['Keyword'] if group.include?('Keywords')
      self.speed_median_load_time = alexa['ContentData']['Speed']['MedianLoadTime'].to_i if group.include?('Speed') and !alexa['ContentData']['Speed']['MedianLoadTime'].empty?
      self.speed_percentile = alexa['ContentData']['Speed']['Percentile'].to_i if group.include?('Speed') and !alexa['ContentData']['Speed']['Percentile'].empty?

      self.related_links = alexa['Related']['RelatedLinks']['RelatedLink'] if group.include?('RelatedLinks')
    end

    private

    def timestamp
      @timestamp ||= Time::now.utc.strftime("%Y-%m-%dT%H:%M:%S.000Z")
    end

    def force_encoding(xml)
      if RUBY_VERSION >= '1.9'
        xml.force_encoding(Encoding::UTF_8)
      else
        xml
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
          self.xml_response = response.body
          xml = XmlSimple.xml_in(response.body, 'ForceArray' => false)
          message = xml['Errors']['Error']['Message']
          raise StandardError.new(message)
        end
      else
        raise StandardError.new("Unknown code: #{respnse.code}")
      end
    end

    def signature
      @signature ||= Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new("sha1"), Alexa.config.secret_access_key, "UrlInfo" + timestamp)).strip
    end

    def url
      URI.parse("http://awis.amazonaws.com/?" +
        {
          "Action"         => "UrlInfo",
          "AWSAccessKeyId" => Alexa.config.access_key_id,
          "Signature"      => signature,
          "Timestamp"      => timestamp,
          "ResponseGroup"  => response_group,
          "Url"            => host,
          "Version"        => API_VERSION
        }.map { |key, value| "#{key}=#{CGI::escape(value)}" }.sort.join("&")
      )
    end
  end
end
