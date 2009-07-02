require 'test_helper'

class AlexaTest < Test::Unit::TestCase
  context "Xml parse" do
    setup do
      @xml = fixture_file('polsl.xml')
      @alexa = Alexa::UrlInfo.new(
        :access_key_id =>  "12345678901234567890",
        :secret_access_key =>  "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDF",
        :host => "some.host"
        )
      @alexa.parse_xml(@xml)
    end

    should "return rank" do
      assert_equal 86049, @alexa.rank
    end

    should "return data url" do
      assert_equal "polsl.pl/", @alexa.data_url
    end

    should "return site title" do
      assert_equal "Silesian University of Technology", @alexa.site_title
    end

    should "return site description" do
      assert_equal "About the university, studies, faculties and departments, photo gallery.", @alexa.site_description
    end

    should "return language locale" do
      assert_equal "pl-PL", @alexa.language_locale
    end

    should "return language encoding" do
      assert_equal "iso-8859-2", @alexa.language_encoding
    end

    should "return links in count" do
      assert_equal 281, @alexa.links_in_count
    end

     should "return keywords" do
      assert_equal ["Polska", "Regionalne", "Gliwice"], @alexa.keywords
    end

     should "return related links" do
       assert_equal 10, @alexa.related_links.count
    end

     should "return speed_median load time" do
       assert_equal 266, @alexa.speed_median_load_time
    end

     should "return speed percentile" do
       assert_equal 98, @alexa.speed_percentile
    end
  end
end
