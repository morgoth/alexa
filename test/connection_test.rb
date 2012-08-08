require "helper"

describe Alexa::Connection do
  it "calculates signature" do
    connection = Alexa::Connection.new(:access_key_id => "fake", :secret_access_key => "fake")
    connection.stubs(:timestamp).returns("2012-08-08T20:58:32.000Z")

    assert_equal "3uaSV1s7uJUtIDivvM8mzPkNxq+Za8jAFCDnQOvjRH4=", connection.signature
  end

  it "normalizes non string params value" do
    connection = Alexa::Connection.new(:access_key_id => "fake", :secret_access_key => "fake")
    connection.stubs(:timestamp).returns("2012-08-08T20:58:32.000Z")
    connection.params = {:custom_value => 3}

    expected = "AWSAccessKeyId=fake&SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp=2012-08-08T20%3A58%3A32.000Z&Version=2005-07-11&custom_value=3"
    assert_equal expected, connection.query
  end

  it "raises error when unathorized" do
    stub_request(:get, %r{http://awis.amazonaws.com}).to_return(fixture("unathorized.txt"))
    connection = Alexa::Connection.new(:access_key_id => "wrong", :secret_access_key => "wrong")

    assert_raises Alexa::ResponseError do
      connection.get
    end
  end

  it "raises error when forbidden" do
    stub_request(:get, %r{http://awis.amazonaws.com}).to_return(fixture("forbidden.txt"))
    connection = Alexa::Connection.new(:access_key_id => "wrong", :secret_access_key => "wrong")

    assert_raises Alexa::ResponseError do
      connection.get
    end
  end
end
