module Vantiv
  class Api::Request
    attr_reader :body

    def initialize(endpoint:, body:, response_object:)
      @endpoint = endpoint
      @body = body
      @response_object = response_object
      @retry_count = 0
    end

    def run
      run_request_with_retries
    end

    def run_request
      http_response = make_json_request

      populated_response(@response_object, http_response)
    end

    private

    def make_json_request
      http = Net::HTTP.new(json_uri.host, json_uri.port)
      http.use_ssl = true
      json_request = Net::HTTP::Post.new(json_uri.request_uri, json_header)
      json_request.body = body.to_json

      http.request(json_request)
    end

    def json_header
      {
        "Content-Type" =>"application/json",
        "Authorization" => "VANTIV license=\"#{Vantiv.license_id}\""
      }
    end

    def json_uri
      @uri ||= URI.parse("#{json_root_uri}/#{@endpoint}")
    end

    def json_root_uri
      if Vantiv::Environment.production?
        "https://apis.vantiv.com"
      elsif Vantiv::Environment.certification?
        "https://apis.cert.vantiv.com"
      end
    end

    def populated_response(response, http_response)
      new_response = response.dup

      new_response.raw_body = http_response.body
      new_response.httpok = http_response.code_type == Net::HTTPOK
      new_response.http_response_code = http_response.code

      response_body = ResponseBodyRepresenter.new(
        Vantiv::Api::ResponseBody.new
      ).from_json(http_response.body)
      new_response.body = response_body

      new_response
    end

    def increment_retry_count
      @retry_count += 1
    end

    def max_retries_exceeded?
      @retry_count > 3
    end

    def run_request_with_retries
      begin
        run_request
      rescue MultiJson::ParseError => e
        increment_retry_count
        max_retries_exceeded? ? raise(e) : retry
      end
    end
  end
end
