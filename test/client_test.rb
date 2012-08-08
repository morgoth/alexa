require "helper"

describe Alexa::Client do
  it "raises Argument Error when access_key_id not present" do
    assert_raises Alexa::ArgumentError, /access_key_id/ do
      Alexa::Client.new(:secret_access_key => "secret")
    end
  end

  it "raises Argument Error when secret_access_key not present" do
    assert_raises Alexa::ArgumentError, /secret_access_key/ do
      Alexa::Client.new(:access_key_id => "key")
    end
  end

  it "fetches UrlInfo results" do
    credentials = {:access_key_id => "key", :secret_access_key => "secret"}
    client = Alexa::Client.new(credentials)
    url_info = stub
    Alexa::API::UrlInfo.expects(:new).with(credentials).returns(url_info)
    url_info.expects(:fetch).with(:url => "github.com")

    client.url_info(:url => "github.com")
  end

  it "fetches SitesLinkingIn results" do
    credentials = {:access_key_id => "key", :secret_access_key => "secret"}
    client = Alexa::Client.new(credentials)
    sites_linking_in = stub
    Alexa::API::SitesLinkingIn.expects(:new).with(credentials).returns(sites_linking_in)
    sites_linking_in.expects(:fetch).with(:url => "github.com", :count => 15, :start => 2)

    client.sites_linking_in(:url => "github.com", :count => 15, :start => 2)
  end

  it "fetches TrafficHistory results" do
    credentials = {:access_key_id => "key", :secret_access_key => "secret"}
    client = Alexa::Client.new(credentials)
    traffic_history = stub
    Alexa::API::TrafficHistory.expects(:new).with(credentials).returns(traffic_history)
    traffic_history.expects(:fetch).with(:url => "github.com", :range => 15)

    client.traffic_history(:url => "github.com", :range => 15)
  end
end
