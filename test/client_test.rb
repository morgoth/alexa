require "helper"

describe Alexa::Client do
  it "raises Argument Error when access_key_id not present" do
    assert_raises ArgumentError, /access_key_id/ do
      Alexa::Client.new(:secret_access_key => "secret")
    end
  end

  it "raises Argument Error when secret_access_key not present" do
    assert_raises ArgumentError, /secret_access_key/ do
      Alexa::Client.new(:access_key_id => "key")
    end
  end

  it "fetches UrlInfo results" do
    client = Alexa::Client.new(:access_key_id => "key", :secret_access_key => "secret")
    url_info = stub
    Alexa::API::UrlInfo.expects(:new).with(client).returns(url_info)
    url_info.expects(:fetch).with(:host => "github.com")

    client.url_info(:host => "github.com")
  end
end
