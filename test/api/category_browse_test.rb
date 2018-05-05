require_relative "../helper"

describe Alexa::API::CategoryBrowse do
  describe "parsing xml" do
    before do
      @category_browse = Alexa::API::CategoryBrowse.new(:access_key_id => ACCESS_KEY_ID, :secret_access_key => SECRET_ACCESS_KEY)
      VCR.use_cassette("category_browse/card_games") do
        @category_browse.fetch(:path => "Top/Games/Card_Games")
      end
    end

    it "returns categories" do
      assert_equal 8, @category_browse.categories.size
    end

    it "returns language categories" do
      assert_equal 20, @category_browse.language_categories.size
    end

    it "returns related categories" do
      assert_equal 8, @category_browse.related_categories.size
    end

    it "returns letter bars" do
      assert_equal 36, @category_browse.letter_bars.size
    end

    it "has success status code" do
      assert_equal "Success", @category_browse.status_code
    end

    it "has request id" do
      refute_nil @category_browse.request_id
    end
  end
end
