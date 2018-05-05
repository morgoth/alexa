require "aws-sigv4"
require "faraday"

module Alexa
  class Connection
    attr_accessor :secret_access_key, :access_key_id
    attr_writer :params

    RFC_3986_UNRESERVED_CHARS = "-_.~a-zA-Z\\d"
    HEADERS = {
      "Content-Type" => "application/xml",
      "Accept" => "application/xml",
      "User-Agent" => "Ruby alexa gem v#{Alexa::VERSION}"
    }

    def initialize(credentials = {})
      self.secret_access_key = credentials.fetch(:secret_access_key)
      self.access_key_id     = credentials.fetch(:access_key_id)
    end

    def params
      @params ||= {}
    end

    def get(params = {})
      self.params = params
      handle_response(request).body.force_encoding(Encoding::UTF_8)
    end

    def handle_response(response)
      case response.status.to_i
      when 200...300
        response
      when 300...600
        if response.body.nil?
          raise ResponseError.new(nil, response)
        else
          xml = MultiXml.parse(response.body)
          message = xml["Response"]["Errors"]["Error"]["Message"]
          raise ResponseError.new(message, response)
        end
      else
        raise ResponseError.new("Unknown code: #{response.code}", response)
      end
    end

    def request
      Faraday.new(uri, headers: headers).get
    end

    def uri
      @uri ||= URI.parse("#{Alexa::API_HOST}/api?" << query)
    end

    def headers
      HEADERS.merge(auth_headers)
    end

    def auth_headers
      signer.sign_request(
        http_method: "GET",
        headers: HEADERS,
        url: uri.to_s
      ).headers
    end

    def signer
      Aws::Sigv4::Signer.new(
        service: "awis",
        region: Alexa::API_REGION,
        access_key_id: access_key_id,
        secret_access_key: secret_access_key
      )
    end

    def query
      params.map do |key, value|
        "#{key}=#{URI.escape(value.to_s, Regexp.new("[^#{RFC_3986_UNRESERVED_CHARS}]"))}"
      end.sort.join("&")
    end
  end
end
