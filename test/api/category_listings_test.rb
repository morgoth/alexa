require "helper"

describe Alexa::API::CategoryListings do
  it "raises argument error when path not present" do
    assert_raises Alexa::ArgumentError, /path/ do
      Alexa::API::CategoryListings.new(:access_key_id => "fake", :secret_access_key => "fake").fetch
    end
  end

  describe "parsing xml" do
    before do
      stub_request(:get, %r{http://awis.amazonaws.com}).to_return(fixture("category_listings/card_games.txt"))
      @category_listings = Alexa::API::CategoryListings.new(:access_key_id => "fake", :secret_access_key => "fake")
      @category_listings.fetch(:path => "Top/Games/Card_Games")
    end

    it "returns recursive count" do
      assert_equal 1051, @category_listings.recursive_count
    end

    it "returns count" do
      assert_equal 1, @category_listings.count
    end

    it "returns listings" do
      assert_equal 20, @category_listings.listings.size
    end

    it "has success status code" do
      assert_equal "Success", @category_listings.status_code
    end
  end
end
