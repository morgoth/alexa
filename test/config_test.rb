require 'test_helper'

class ConfigTest < Test::Unit::TestCase
  should "Raise argumment error if access key id is not present" do
    assert_raise ArgumentError do
      Alexa::UrlInfo.new(
      :secret_access_key =>  "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDF",
      :host => "some.host"
      )
    end
  end

  should "Raise argumment error if secret access key is not present" do
    assert_raise ArgumentError do
      Alexa::UrlInfo.new(
      :access_key_id =>  "12345678901234567890",
      :host => "some.host"
      )
    end
  end

  should "Raise argumment error if host is not present" do
    assert_raise ArgumentError do
      Alexa::UrlInfo.new(
      :access_key_id =>  "12345678901234567890",
      :secret_access_key =>  "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDF"
      )
    end
  end
end