require_relative "../helper"

describe Alexa::API::UrlInfo do
  it "raises argument error when url not present" do
    assert_raises Alexa::ArgumentError, /url/ do
      Alexa::API::UrlInfo.new(:access_key_id => "fake", :secret_access_key => "fake").fetch
    end
  end

  describe "parsing xml returned by options rank, links_in_count, site_data" do
    before do
      @url_info = Alexa::API::UrlInfo.new(:access_key_id => ACCESS_KEY_ID, :secret_access_key => SECRET_ACCESS_KEY)
      VCR.use_cassette("url_info/github") do
        @url_info.fetch(:url => "github.com", :response_group => ["rank", "links_in_count", "site_data"])
      end
    end

    it "returns rank" do
      assert_equal 63, @url_info.rank
    end

    it "returns data url" do
      assert_equal "github.com/", @url_info.data_url
    end

    it "returns site title" do
      assert_equal "GitHub", @url_info.site_title
    end

    it "has request id" do
      refute_nil @url_info.request_id
    end
  end

  describe "with github.com full response group" do
    before do
      @url_info = Alexa::API::UrlInfo.new(:access_key_id => ACCESS_KEY_ID, :secret_access_key => SECRET_ACCESS_KEY)
      VCR.use_cassette("url_info/github-full") do
        @url_info.fetch(:url => "github.com")
      end
    end

    it "returns rank" do
      assert_equal 63, @url_info.rank
    end

    it "returns data url" do
      assert_equal "github.com", @url_info.data_url
    end

    it "returns site title" do
      assert_equal "GitHub", @url_info.site_title
    end

    it "returns site description" do
      expected = "GitHub is the best place to share code with friends, co-workers, classmates, and complete strangers. Over four million people use GitHub to build amazing things together."
      assert_equal expected, @url_info.site_description
    end

    it "returns language locale" do
      assert_nil @url_info.language_locale
    end

    it "returns language encoding" do
      assert_nil @url_info.language_encoding
    end

    it "returns links in count" do
      assert_equal 99073, @url_info.links_in_count
    end

    it "returns keywords" do
      assert_nil @url_info.keywords
    end

    it "returns related links" do
      assert_equal 10, @url_info.related_links.size
    end

    it "returns speed_median load time" do
      assert_equal 1825, @url_info.speed_median_load_time
    end

    it "returns speed percentile" do
      assert_equal 52, @url_info.speed_percentile
    end

    it "returns rank by country" do
      assert_equal 29, @url_info.rank_by_country.size
    end

    it "returns usage statistics" do
      assert_equal 4, @url_info.usage_statistics.size
    end

    it "returns categories" do
      assert_equal 2, @url_info.categories.size
    end

    it "has success status code" do
      assert_equal "Success", @url_info.status_code
    end
  end
end
