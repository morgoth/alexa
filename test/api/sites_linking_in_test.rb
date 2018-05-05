require_relative "../helper"

describe Alexa::API::SitesLinkingIn do
  describe "parsing xml" do
    before do
      @sites_linking_in = Alexa::API::SitesLinkingIn.new(:access_key_id => ACCESS_KEY_ID, :secret_access_key => SECRET_ACCESS_KEY)
      VCR.use_cassette("sites_linking_in/github") do
        @sites_linking_in.fetch(:url => "github.com", :count => 3)
      end
    end

    it "returns sites" do
      assert_equal 3, @sites_linking_in.sites.size
    end

    it "has Title attribute on single site" do
      assert_equal "baidu.com", @sites_linking_in.sites.first["Title"]
    end

    it "has Url attribute on single site" do
      assert_equal "anquan.baidu.com:80/bbs/forum.php?mod=viewthread&tid=86532", @sites_linking_in.sites.first["Url"]
    end

    it "has success status code" do
      assert_equal "Success", @sites_linking_in.status_code
    end

    it "has request id" do
      refute_nil @sites_linking_in.request_id
    end
  end
end
