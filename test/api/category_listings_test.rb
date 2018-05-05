require_relative "../helper"

describe Alexa::API::CategoryListings do
  describe "parsing xml" do
    before do
      @category_listings = Alexa::API::CategoryListings.new(:access_key_id => ACCESS_KEY_ID, :secret_access_key => SECRET_ACCESS_KEY)
      VCR.use_cassette("category_listings/card_games") do
        @category_listings.fetch(:path => "Top/Games/Card_Games")
      end
    end

    it "returns recursive count" do
      assert_equal 799, @category_listings.recursive_count
    end

    it "returns count" do
      assert_equal 0, @category_listings.count
    end

    it "returns listings" do
      assert_equal 20, @category_listings.listings.size
    end

    it "has success status code" do
      assert_equal "Success", @category_listings.status_code
    end

    it "has request id" do
      refute_nil @category_listings.request_id
    end
  end
end
