require "helper"

describe Alexa::API::SitesLinkingIn do
  it "raises argument error when url not present" do
    assert_raises Alexa::ArgumentError, /url/ do
      Alexa::API::SitesLinkingIn.new(:access_key_id => "fake", :secret_access_key => "fake").fetch
    end
  end

  describe "parsing xml" do
    before do
      stub_request(:get, %r{http://awis.amazonaws.com}).to_return(fixture("sites_linking_in/github_count_3.txt"))
      @sites_linking_in = Alexa::API::SitesLinkingIn.new(:access_key_id => "fake", :secret_access_key => "fake")
      @sites_linking_in.fetch(:url => "github.com", :count => 3)
    end

    it "returns sites" do
      assert_equal 3, @sites_linking_in.sites.size
    end

    it "has Title attribute on single site" do
      assert_equal "google.com", @sites_linking_in.sites.first["Title"]
    end

    it "has Url attribute on single site" do
      assert_equal "code.google.com:80/a/eclipselabs.org/p/m2eclipse-android-integration", @sites_linking_in.sites.first["Url"]
    end
  end
end
