require "helper"

describe Alexa::API::UrlInfo do
  it "allows to pass single attribute as response_group" do
    stub_request(:get, %r{http://awis.amazonaws.com}).to_return(:body => "ok")
    @url_info = Alexa::API::UrlInfo.new(:access_key_id => "fake", :secret_access_key => "fake")
    @url_info.fetch(host: "github.com", response_group: "rank")

    assert_equal ["rank"], @url_info.response_group
  end

  describe "parsing xml returned by options rank, links_in_count, site_data" do
    before do
      stub_request(:get, %r{http://awis.amazonaws.com}).to_return(fixture("custom-response-group.txt"))
      @url_info = Alexa::API::UrlInfo.new(:access_key_id => "fake", :secret_access_key => "fake")
      @url_info.fetch(host: "github.com", response_group: ["rank", "links_in_count", "site_data"])
    end

    it "returns rank" do
      assert_equal 493, @url_info.rank
    end

    it "returns data url" do
      assert_equal "github.com/", @url_info.data_url
    end

    it "returns site title" do
      assert_equal "GitHub", @url_info.site_title
    end

    it "returns site description" do
      expected = "Online project hosting using Git. Includes source-code browser, in-line editing, wikis, and ticketing. Free for public open-source code. Commercial closed source hosting is also available."

      assert_equal expected, @url_info.site_description
    end
  end

  describe "with github.com full response group" do
    before do
      stub_request(:get, %r{http://awis.amazonaws.com}).to_return(fixture("github_full.txt"))
      @url_info = Alexa::API::UrlInfo.new(:access_key_id => "fake", :secret_access_key => "fake")
      @url_info.fetch(host: "github.com")
    end

    it "returns rank" do
      assert_equal 551, @url_info.rank
    end

    it "returns data url" do
      assert_equal "github.com", @url_info.data_url
    end

    it "returns site title" do
      assert_equal "GitHub", @url_info.site_title
    end

    it "returns site description" do
      expected = "Online project hosting using Git. Includes source-code browser, in-line editing, wikis, and ticketing. Free for public open-source code. Commercial closed source hosting is also available."
      assert_equal expected, @url_info.site_description
    end

    it "returns language locale" do
      assert_nil @url_info.language_locale
    end

    it "returns language encoding" do
      assert_nil @url_info.language_encoding
    end

    it "returns links in count" do
      assert_equal 43819, @url_info.links_in_count
    end

    it "returns keywords" do
      assert_nil @url_info.keywords
    end

    it "returns related links" do
      assert_equal 10, @url_info.related_links.size
    end

    it "returns speed_median load time" do
      assert_equal 1031, @url_info.speed_median_load_time
    end

    it "returns speed percentile" do
      assert_equal 68, @url_info.speed_percentile
    end

    it "returns rank by country" do
      assert_equal 19, @url_info.rank_by_country.size
    end

    it "returns rank by city" do
      assert_equal 163, @url_info.rank_by_city.size
    end

    it "returns usage statistics" do
      assert_equal 4, @url_info.usage_statistics.size
    end
  end

  describe "with github.com rank response group" do
    it "successfuly connects" do
      stub_request(:get, %r{http://awis.amazonaws.com}).to_return(fixture("github_rank.txt"))
      @url_info = Alexa::API::UrlInfo.new(:access_key_id => "fake", :secret_access_key => "fake")
      @url_info.fetch(host: "github.com", response_group: ["rank"])

      assert_equal 551, @url_info.rank
    end
  end

  describe "parsing xml with failure" do
    it "raises error when unathorized" do
      stub_request(:get, %r{http://awis.amazonaws.com}).to_return(fixture("unathorized.txt"))
      @url_info = Alexa::API::UrlInfo.new(:access_key_id => "wrong", :secret_access_key => "wrong")


      assert_raises StandardError do
        @url_info.fetch(host: "github.com")
      end
    end

    it "raises error when forbidden" do
      stub_request(:get, %r{http://awis.amazonaws.com}).to_return(fixture("forbidden.txt"))
      @url_info = Alexa::API::UrlInfo.new(:access_key_id => "wrong", :secret_access_key => "wrong")

      assert_raises StandardError do
        @url_info.fetch(host: "github.com")
      end
    end
  end
end
