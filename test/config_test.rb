require "helper"

describe Alexa do
  before do
    Alexa.access_key_id = nil
    Alexa.secret_access_key = nil
  end

  it "raises argumment error if access key id is not present" do
    assert_raises ArgumentError do
      Alexa::UrlInfo.new(
        :secret_access_key => "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDF",
        :host => "some.host"
      )
    end
  end

  it "raises argumment error if secret access key is not present" do
    assert_raises ArgumentError do
      Alexa::UrlInfo.new(
        :access_key_id => "12345678901234567890",
        :host => "some.host"
      )
    end
  end

  it "raises argumment error if host is not present" do
    assert_raises ArgumentError do
      Alexa::UrlInfo.new(
        :access_key_id => "12345678901234567890",
        :secret_access_key => "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDF"
      )
    end
  end
end
