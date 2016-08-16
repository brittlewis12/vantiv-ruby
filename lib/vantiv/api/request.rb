module Vantiv
  class Api::Request
    attr_reader :body

    def initialize(endpoint:, body:, response_object:)
      @endpoint = endpoint
      @body = body.to_json
      @response_object = response_object
      @retry_count = 0
    end

    def run
      run_request_with_retries
    end

    def run_request
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(uri.request_uri, header)
      request.body = body

      http_response = http.request(request)

      populated_response(@response_object, http_response)
    end

    private

    def populated_response(response, http_response)
      new_response = response.dup
      response_body = ResponseBodyRepresenter.new(
        Vantiv::Api::ResponseBody.new
      ).from_json(http_response.body)

      new_response.body = response_body
      new_response.httpok = http_response.code_type == Net::HTTPOK
      new_response.http_response_code = http_response.code
      new_response
    end

    def header
      {
        "Content-Type" =>"application/json",
        "Authorization" => "VANTIV license=\"#{Vantiv.license_id}\""
      }
    end

    def uri
      @uri ||= URI.parse("#{root_uri}/#{@endpoint}")
    end

    def root_uri
      if Vantiv::Environment.production?
        "https://apis.vantiv.com"
      elsif Vantiv::Environment.certification?
        "https://apis.cert.vantiv.com"
      end
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
