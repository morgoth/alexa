module Alexa
  class Connection
    attr_reader :secret_access_key, :access_key_id, :params

    def initialize(credentials = {})
      @secret_access_key = credentials.fetch(:secret_access_key)
      @access_key_id     = credentials.fetch(:access_key_id)
    end

    def get(params = {})
      @params = params
      encode handle_response(request).body
    end

    def handle_response(response)
      case response.code.to_i
      when 200...300
        response
      when 300...600
        if response.body.nil?
          raise StandardError.new(response)
        else
          xml = MultiXml.parse(response.body)
          message = xml["Response"]["Errors"]["Error"]["Message"]
          raise StandardError.new(message)
        end
      else
        raise StandardError.new("Unknown code: #{respnse.code}")
      end
    end

    def request
      Net::HTTP.get_response(url)
    end

    def timestamp
      @timestamp ||= Time::now.utc.strftime("%Y-%m-%dT%H:%M:%S.000Z")
    end

    def signature
      Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new("sha1"), secret_access_key, sign)).strip
    end

    def url
      URI.parse("http://#{Alexa::API_HOST}/?" + query + "&Signature=" + CGI::escape(signature))
    end

    def default_params
      {
        "AWSAccessKeyId"   => access_key_id,
        "SignatureMethod"  => "HmacSHA1",
        "SignatureVersion" => "2",
        "Timestamp"        => timestamp,
        "Version"          => Alexa::API_VERSION
      }
    end

    def sign
      "GET\n" + Alexa::API_HOST + "\n/\n" + query
    end

    def query
      default_params.merge(params).map { |key, value| "#{key}=#{CGI::escape(value)}" }.sort.join("&")
    end

    def encode(string)
      if "muflon".respond_to?(:force_encoding)
        string.force_encoding(Encoding::UTF_8)
      else
        string
      end
    end
  end
end
