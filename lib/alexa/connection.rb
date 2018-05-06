require "cgi"
require "aws-sigv4"
require "net/https"

module Alexa
  class Connection
    attr_reader :params, :secret_access_key, :access_key_id

    HEADERS = {
      "Content-Type" => "application/xml",
      "Accept" => "application/xml",
      "User-Agent" => "Ruby alexa gem v#{Alexa::VERSION}"
    }

    def initialize(credentials = {})
      @secret_access_key = credentials.fetch(:secret_access_key)
      @access_key_id     = credentials.fetch(:access_key_id)
    end

    def get(params = {})
      @params = params
      handle_response(request).body.force_encoding(Encoding::UTF_8)
    end

    private

    def handle_response(response)
      case response
      when Net::HTTPSuccess
        response
      else
        raise ResponseError.new(response.body, response)
      end
    end

    def request
      req = Net::HTTP::Get.new(uri)
      headers.each do |key, value|
        req[key] = value
      end
      Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(req)
      end
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
        "#{key}=#{CGI.escape(value.to_s)}"
      end.sort!.join("&")
    end
  end
end
