require "helper"

describe Alexa::Connection do
  it "raises error when unathorized" do
    skip("TODO: fix")
    connection = Alexa::Connection.new(:access_key_id => "wrong", :secret_access_key => "wrong")

    assert_raises Alexa::ResponseError do
      VCR.use_cassette("unathorized") do
        connection.get
      end
    end
  end
end
