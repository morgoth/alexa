module Alexa::API
  class CategoryBrowse
    include Alexa::Utils

    DEFAULT_RESPONSE_GROUP = ["categories", "related_categories", "language_categories", "letter_bars"]

    attr_reader :response_group, :path, :descriptions, :response_body

    def initialize(credentials)
      @credentials = credentials
    end

    def fetch(arguments = {})
      @path           = arguments[:path] || raise(ArgumentError.new("You must specify path"))
      @response_group = Array(arguments.fetch(:response_group, DEFAULT_RESPONSE_GROUP))
      @descriptions   = arguments.fetch(:descriptions, true)
      @response_body  = Alexa::Connection.new(@credentials).get(params)
      self
    end

    # Attributes

    def categories
      @categories ||= safe_retrieve(parsed_body, "CategoryBrowseResponse", "Response", "CategoryBrowseResult", "Alexa", "CategoryBrowse", "Categories", "Category")
    end

    def language_categories
      @language_categories ||= safe_retrieve(parsed_body, "CategoryBrowseResponse", "Response", "CategoryBrowseResult", "Alexa", "CategoryBrowse", "LanguageCategories", "Category")
    end

    def related_categories
      @related_categories ||= safe_retrieve(parsed_body, "CategoryBrowseResponse", "Response", "CategoryBrowseResult", "Alexa", "CategoryBrowse", "RelatedCategories", "Category")
    end

    def letter_bars
      @letter_bars ||= safe_retrieve(parsed_body, "CategoryBrowseResponse", "Response", "CategoryBrowseResult", "Alexa", "CategoryBrowse", "LetterBars", "Category")
    end

    private

    def params
      {
        "Action"        => "CategoryBrowse",
        "ResponseGroup" => response_group_param,
        "Path"          => path,
        "Descriptions"  => descriptions_param
      }
    end

    def response_group_param
      response_group.sort.map { |group| camelize(group) }.join(",")
    end

    def descriptions_param
      descriptions.to_s.capitalize
    end

    def parsed_body
      @parsed_body ||= MultiXml.parse(response_body)
    end
  end
end
