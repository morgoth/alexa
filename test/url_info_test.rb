require "helper"

describe "Alexa::UlrInfo" do
  before do
    @alexa = Alexa::UrlInfo.new(
      :access_key_id => "12345678901234567890",
      :secret_access_key => "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDF",
      :host => "some.host"
    )
  end

  it "should Generate signature" do
    @alexa.stubs(:timestamp).returns("2009-07-03T07:22:24.000Z")
    assert_equal "5Jql3rds3vL9hyijnYtUIVv1H8Q=", @alexa.send(:signature)
  end

  it "should Generate url" do
    @alexa.stubs(:timestamp).returns("2009-07-03T07:22:24.000Z")
    @alexa.response_group = "Rank,ContactInfo,AdultContent,Speed,Language,Keywords,OwnedDomains,LinksInCount,SiteData,RelatedLinks"
    @alexa.host = "heroku.com"
    expected_uri = "/?AWSAccessKeyId=12345678901234567890&Action=UrlInfo&ResponseGroup=Rank%2CContactInfo%2CAdultContent%2CSpeed%2CLanguage%2CKeywords%2COwnedDomains%2CLinksInCount%2CSiteData%2CRelatedLinks&SignatureMethod=HmacSHA1&SignatureVersion=2&Timestamp=2009-07-03T07%3A22%3A24.000Z&Url=heroku.com&Version=2005-07-11&Signature=H9VtDwXGXT5O8NodLOlsc2wIfv8%3D"
    assert_equal expected_uri, @alexa.send(:url).request_uri
    assert_equal "awis.amazonaws.com", @alexa.send(:url).host
  end

  describe "parsing xml returned by options Rank,LinksInCount,SiteData" do
    before do
      FakeWeb.register_uri(:get, %r{http://awis.amazonaws.com}, :response => fixture("custom-response-group.txt"))
      @alexa.response_group = "Rank,LinksInCount,SiteData"
      @alexa.connect
      @alexa.parse_xml(@alexa.xml_response)
    end

    it "should return rank" do
      assert_equal 493, @alexa.rank
    end

    it "should return data url" do
      assert_equal "github.com/", @alexa.data_url
    end

    it "should return site title" do
      assert_equal "GitHub", @alexa.site_title
    end

    it "should return site description" do
      expected = "Online project hosting using Git. Includes source-code browser, in-line editing, wikis, and ticketing. Free for public open-source code. Commercial closed source hosting is also available."
      assert_equal expected, @alexa.site_description
    end

    it "should not have other attributes" do
      assert_nil @alexa.language_locale
    end
  end

  describe "with github.com full response group" do
    before do
      FakeWeb.register_uri(:get, %r{http://awis.amazonaws.com}, :response => fixture("github_full.txt"))
      @alexa.connect
      @alexa.parse_xml(@alexa.xml_response)
    end

    it "should return rank" do
      assert_equal 551, @alexa.rank
    end

    it "should return data url" do
      assert_equal "github.com", @alexa.data_url
    end

    it "should return site title" do
      assert_equal "GitHub", @alexa.site_title
    end

    it "should return site description" do
      expected = "Online project hosting using Git. Includes source-code browser, in-line editing, wikis, and ticketing. Free for public open-source code. Commercial closed source hosting is also available."
      assert_equal expected, @alexa.site_description
    end

    it "should return language locale" do
      assert_nil @alexa.language_locale
    end

    it "should return language encoding" do
      assert_nil @alexa.language_encoding
    end

    it "should return links in count" do
      assert_equal 43819, @alexa.links_in_count
    end

    it "should return keywords" do
      assert_nil @alexa.keywords
    end

    it "should return related links" do
      assert_equal 10, @alexa.related_links.size
    end

    it "should return speed_median load time" do
      assert_equal 1031, @alexa.speed_median_load_time
    end

    it "should return speed percentile" do
      assert_equal 68, @alexa.speed_percentile
    end

    it "should return rank by country" do
      assert_equal 19, @alexa.rank_by_country.size
    end

    it "should return rank by city" do
      assert_equal 163, @alexa.rank_by_city.size
    end

    it "should return usage statistics" do
      assert_equal 4, @alexa.usage_statistics.size
    end
  end

  describe "with github.com rank response group" do
    it "should successfuly connect" do
      FakeWeb.register_uri(:get, %r{http://awis.amazonaws.com}, :response => fixture("github_rank.txt"))
      @alexa.response_group = "Rank"
      @alexa.connect
      @alexa.parse_xml(@alexa.xml_response)
      assert_equal 551, @alexa.rank
    end
  end

  describe "parsing xml with failure" do
    it "should raise error when unathorized" do
      FakeWeb.register_uri(:get, %r{http://awis.amazonaws.com}, :response => fixture("unathorized.txt"))
      assert_raises StandardError do
        @alexa.connect
      end
    end

    it "should raise error when forbidden" do
      FakeWeb.register_uri(:get, %r{http://awis.amazonaws.com}, :response => fixture("forbidden.txt"))
      assert_raises StandardError do
        @alexa.connect
      end
    end
  end
end
