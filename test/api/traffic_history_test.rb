require "helper"

describe Alexa::API::TrafficHistory do
  it "raises argument error when url not present" do
    assert_raises Alexa::ArgumentError, /url/ do
      Alexa::API::TrafficHistory.new(:access_key_id => "fake", :secret_access_key => "fake").fetch
    end
  end

  it "defaults start to be in range to current time" do
    stub_request(:get, %r{http://awis.amazonaws.com}).to_return(:body => "ok")
    @traffic_history = Alexa::API::TrafficHistory.new(:access_key_id => "fake", :secret_access_key => "fake")
    @traffic_history.fetch(:url => "github.com", :range => 14)

    # 14 days from now
    assert_in_delta (Time.now - 3600 * 24 * 14).to_i, @traffic_history.arguments[:start].to_i, 0.001
  end

  describe "parsing xml" do
    before do
      stub_request(:get, %r{http://awis.amazonaws.com}).to_return(fixture("traffic_history/github.txt"))
      @traffic_history = Alexa::API::TrafficHistory.new(:access_key_id => "fake", :secret_access_key => "fake")
      @traffic_history.fetch(:url => "github.com")
    end

    it "returns site" do
      assert_equal "github.com", @traffic_history.site
    end

    it "returns range" do
      assert_equal 28, @traffic_history.range
    end

    it "returns start" do
      assert_equal "2012-07-11", @traffic_history.start
    end

    it "returns data" do
      assert_equal 28, @traffic_history.data.size
    end

    it "has success status code" do
      assert_equal "Success", @traffic_history.status_code
    end

    it "has request id" do
      assert_equal "617614fc-46a3-a105-a7ab-80a17f117bcf", @traffic_history.request_id
    end
  end

  it "has error status code" do
    stub_request(:get, %r{http://awis.amazonaws.com}).to_return(fixture("traffic_history/alexa_error.txt"))
    traffic_history = Alexa::API::TrafficHistory.new(:access_key_id => "fake", :secret_access_key => "fake")
    traffic_history.fetch(:url => "amazon.com")

    assert_equal "AlexaError", traffic_history.status_code
  end
end
