require "helper"

describe Alexa::Connection do
  it "raises error when unathorized" do
    stub_request(:get, %r{http://awis.amazonaws.com}).to_return(fixture("unathorized.txt"))
    @connection = Alexa::Connection.new(:access_key_id => "wrong", :secret_access_key => "wrong")

    assert_raises Alexa::ResponseError do
      @connection.get
    end
  end

  it "raises error when forbidden" do
    stub_request(:get, %r{http://awis.amazonaws.com}).to_return(fixture("forbidden.txt"))
    @connection = Alexa::Connection.new(:access_key_id => "wrong", :secret_access_key => "wrong")

    assert_raises Alexa::ResponseError do
      @connection.get
    end
  end
end
