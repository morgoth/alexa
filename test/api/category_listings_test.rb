require "helper"

describe Alexa::API::CategoryListings do
  describe "parsing xml" do
    before do
      stub_request(:get, %r{http://awis.amazonaws.com}).to_return(fixture("category_listings/card_games.txt"))
      @category_listings = Alexa::API::CategoryListings.new(:access_key_id => "fake", :secret_access_key => "fake")
      @category_listings.fetch(:path => "Top/Games/Card_Games")
    end

    it "returns recursive count" do
      assert_equal 1051, @category_listings.recursive_count
    end

    it "returns listings" do
      assert_equal 20, @category_listings.listings.size
    end
  end
end
