module Alexa::API
  class CategoryBrowse
    include Alexa::Utils

    DEFAULT_RESPONSE_GROUP = ["categories", "related_categories", "language_categories", "letter_bars"]

    attr_reader :arguments, :response_body

    def initialize(credentials)
      @credentials = credentials
    end

    def fetch(arguments = {})
      raise ArgumentError, "You must specify path" unless arguments.has_key?(:path)
      @arguments = arguments

      @arguments[:response_group] = Array(arguments.fetch(:response_group, DEFAULT_RESPONSE_GROUP))
      @arguments[:descriptions]   = arguments.fetch(:descriptions, true)

      @response_body = Alexa::Connection.new(@credentials).get(params)
      self
    end

    def parsed_body
      @parsed_body ||= MultiXml.parse(response_body)
    end

    # Response attributes

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
        "Path"          => arguments[:path],
        "Descriptions"  => descriptions_param
      }
    end

    def response_group_param
      arguments[:response_group].sort.map { |group| camelize(group) }.join(",")
    end

    def descriptions_param
      arguments[:descriptions].to_s.capitalize
    end
  end
end
