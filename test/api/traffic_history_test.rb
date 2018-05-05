require_relative "../helper"

describe Alexa::API::TrafficHistory do
  it "raises argument error when url not present" do
    assert_raises Alexa::ArgumentError, /url/ do
      Alexa::API::TrafficHistory.new(:access_key_id => "fake", :secret_access_key => "fake").fetch
    end
  end

  describe "parsing xml" do
    before do
      @traffic_history = Alexa::API::TrafficHistory.new(:access_key_id => ACCESS_KEY_ID, :secret_access_key => SECRET_ACCESS_KEY)
      VCR.use_cassette("traffic_history/github") do
        @traffic_history.fetch(:url => "github.com", :start => "20180404")
      end
    end

    it "returns site" do
      assert_equal "github.com", @traffic_history.site
    end

    it "returns range" do
      assert_equal 31, @traffic_history.range
    end

    it "returns start" do
      assert_equal "2018-04-04", @traffic_history.start
    end

    it "returns data" do
      assert_equal 31, @traffic_history.data.size
    end

    it "has success status code" do
      assert_equal "Success", @traffic_history.status_code
    end

    it "has request id" do
      refute_nil @traffic_history.request_id
    end
  end
end
