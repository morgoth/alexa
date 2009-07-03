require 'test_helper'

class AlexaTest < Test::Unit::TestCase
  context "Alexa::UrlInfo" do
    setup do
      @alexa = Alexa::UrlInfo.new(
        :access_key_id =>  "12345678901234567890",
        :secret_access_key =>  "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDF",
        :host => "some.host"
        )
    end

    should "Generate signature" do
      signature = @alexa.send :generate_signature, @alexa.secret_access_key, "UrlInfo", '2009-07-03T07:22:24.000Z'
      assert_equal "I1mPdBy+flhhzqqUaamNq9gq190=", signature
    end

    should "Generatee url" do
      url = @alexa.send( :generate_url,
        "UrlInfo",
        @alexa.access_key_id,
        "I1mPdBy+flhhzqqUaamNq9gq190=",
        '2009-07-03T07:22:24.000Z',
        "Rank,ContactInfo,AdultContent,Speed,Language,Keywords,OwnedDomains,LinksInCount,SiteData,RelatedLinks",
        "heroku.com"
        )
      expected_uri = "/?Action=UrlInfo&AWSAccessKeyId=12345678901234567890&Signature=I1mPdBy%2BflhhzqqUaamNq9gq190%3D&Timestamp=2009-07-03T07%3A22%3A24.000Z&ResponseGroup=Rank%2CContactInfo%2CAdultContent%2CSpeed%2CLanguage%2CKeywords%2COwnedDomains%2CLinksInCount%2CSiteData%2CRelatedLinks&Url=heroku.com"
      assert_equal expected_uri, url.request_uri
      assert_equal "awis.amazonaws.com", url.host
    end

    context "should parse xml return by options LinksInCount,SiteData and" do
      setup do
        @alexa.response_group = "Rank,LinksInCount,SiteData"
        xml = fixture_file('polsl_small.xml')
        @alexa.parse_xml(xml)
      end

      should "return rank" do
        assert_equal 86020, @alexa.rank
      end

      should "return data url" do
        assert_equal "polsl.pl/", @alexa.data_url
      end

      should "return site title" do
        assert_equal "Silesian University of Technology", @alexa.site_title
      end

      should "return site description" do
        assert_equal "About the university, studies, faculties and departments, photo gallery.", @alexa.site_description
      end

      should "not crush" do
        assert_nothing_raised do
          @alexa.language_locale
        end
        assert_nil @alexa.language_locale
      end
    end

    context "should parse xml with all options and" do
      setup do
        xml = fixture_file('polsl.xml')
        @alexa.parse_xml(xml)
      end

      should "return rank" do
        assert_equal 86020, @alexa.rank
      end

      should "return data url" do
        assert_equal "polsl.pl", @alexa.data_url
      end

      should "return site title" do
        assert_equal "Silesian University of Technology", @alexa.site_title
      end

      should "return site description" do
        assert_equal "About the university, studies, faculties and departments, photo gallery.", @alexa.site_description
      end

      should "return language locale" do
        assert_equal "pl-PL", @alexa.language_locale
      end

      should "return language encoding" do
        assert_equal "iso-8859-2", @alexa.language_encoding
      end

      should "return links in count" do
        assert_equal 281, @alexa.links_in_count
      end

      should "return keywords" do
        assert_equal ["Polska", "Regionalne", "Gliwice"], @alexa.keywords
      end

      should "return related links" do
        assert_equal 10, @alexa.related_links.count
      end

      should "return speed_median load time" do
        assert_equal 266, @alexa.speed_median_load_time
      end

      should "return speed percentile" do
        assert_equal 98, @alexa.speed_percentile
      end

      should "return rank by country" do
        assert_equal 3, @alexa.rank_by_country.count
      end

      should "return rank by city" do
        assert_equal 68, @alexa.rank_by_city.count
      end

      should "return usage statistics" do
        assert_equal 4, @alexa.usage_statistics.count
      end

    end
  end

  should "Raise argumment error if keys or host are not present" do
    assert_raise ArgumentError, do
      Alexa::UrlInfo.new(
        :secret_access_key =>  "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDF",
        :host => "some.host"
      )
    end

    assert_raise ArgumentError, do
      Alexa::UrlInfo.new(
        :access_key_id =>  "12345678901234567890",
        :host => "some.host"
      )
    end

    assert_raise ArgumentError, do
      Alexa::UrlInfo.new(
        :access_key_id =>  "12345678901234567890",
        :secret_access_key =>  "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDF",
      )
    end
  end
end
