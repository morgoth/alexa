require "helper"

class UrlInfoTest < Test::Unit::TestCase
  def setup
    @alexa = Alexa::UrlInfo.new(
      :access_key_id => "12345678901234567890",
      :secret_access_key => "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDF",
      :host => "some.host"
    )
  end

  should "Generate signature" do
    @alexa.stubs(:timestamp).returns("2009-07-03T07:22:24.000Z")
    assert_equal "I1mPdBy+flhhzqqUaamNq9gq190=", @alexa.send(:signature)
  end

  should "Generate url" do
    @alexa.stubs(:timestamp).returns("2009-07-03T07:22:24.000Z")
    @alexa.response_group = "Rank,ContactInfo,AdultContent,Speed,Language,Keywords,OwnedDomains,LinksInCount,SiteData,RelatedLinks"
    @alexa.host = "heroku.com"
    expected_uri = "/?AWSAccessKeyId=12345678901234567890&Action=UrlInfo&ResponseGroup=Rank%2CContactInfo%2CAdultContent%2CSpeed%2CLanguage%2CKeywords%2COwnedDomains%2CLinksInCount%2CSiteData%2CRelatedLinks&Signature=I1mPdBy%2BflhhzqqUaamNq9gq190%3D&Timestamp=2009-07-03T07%3A22%3A24.000Z&Url=heroku.com&Version=2005-07-11"
    assert_equal expected_uri, @alexa.send(:url).request_uri
    assert_equal "awis.amazonaws.com", @alexa.send(:url).host
  end

  context "should parse xml return by options LinksInCount,SiteData" do
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

    should "not crash" do
      assert_nothing_raised do
        @alexa.language_locale
      end
      assert_nil @alexa.language_locale
    end
  end

  context "should parse xml with all options" do
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
      assert_equal 10, @alexa.related_links.size
    end

    should "return speed_median load time" do
      assert_equal 266, @alexa.speed_median_load_time
    end

    should "return speed percentile" do
      assert_equal 98, @alexa.speed_percentile
    end

    should "return rank by country" do
      assert_equal 3, @alexa.rank_by_country.size
    end

    should "return rank by city" do
      assert_equal 68, @alexa.rank_by_city.size
    end

    should "return usage statistics" do
      assert_equal 4, @alexa.usage_statistics.size
    end
  end

  context "should not crash when parsing empty xml response" do
    setup do
      xml = fixture_file('empty.xml')
      @alexa.parse_xml(xml)
    end

    should "return nil from rank" do
      assert_nil @alexa.rank
    end

    should "return nil from data_url" do
      assert_equal "404", @alexa.data_url
    end

    should "return nil from site_title" do
      assert_equal "404", @alexa.site_title
    end

    should "return nil from site_description" do
      assert_nil @alexa.site_description
    end

    should "return nil from language_locale" do
      assert_nil @alexa.language_locale
    end

    should "return nil from language_encoding" do
      assert_nil @alexa.language_encoding
    end

    should "return nil from links_in_count" do
      assert_nil @alexa.links_in_count
    end

    should "return nil from keywords" do
      assert_nil @alexa.keywords
    end

    should "return nil from related_links" do
      assert_nil @alexa.related_links
    end

    should "return nil from speed_median_load_time" do
      assert_nil @alexa.speed_median_load_time
    end

    should "return nil from speed_percentile" do
      assert_nil @alexa.speed_percentile
    end

    should "return nil from rank_by_country" do
      assert_nil @alexa.rank_by_country
    end

    should "return nil from rank_by_city" do
      assert_nil @alexa.rank_by_city
    end

    should "return nil from usage_statistics" do
      assert_nil @alexa.usage_statistics
    end
  end

  should "not raise error when response is OK" do
    assert_nothing_raised do
      @alexa.send :handle_response, Net::HTTPOK.new("1.1", "200", "OK")
    end
  end
end
