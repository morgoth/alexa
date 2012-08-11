require "helper"

describe Alexa::API::CategoryBrowse do
  it "raises argument error when path not present" do
    assert_raises Alexa::ArgumentError, /path/ do
      Alexa::API::CategoryBrowse.new(:access_key_id => "fake", :secret_access_key => "fake").fetch
    end
  end

  describe "parsing xml" do
    before do
      stub_request(:get, %r{http://awis.amazonaws.com}).to_return(fixture("category_browse/card_games.txt"))
      @category_browse = Alexa::API::CategoryBrowse.new(:access_key_id => "fake", :secret_access_key => "fake")
      @category_browse.fetch(:path => "Top/Games/Card_Games")
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
  end
end
