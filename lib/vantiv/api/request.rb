module Vantiv
  class Api::Request
    attr_reader :body

    ENDPOINT_XML_TRANSACTION_TYPE = {
      :"payment/sp2/credit/v1/authorization" => :authorization,
      :"payment/sp2/credit/v1/authorizationCompletion" => :capture,
      :"payment/sp2/credit/v1/reversal" => :authReversal,
      :"payment/sp2/credit/v1/sale" => :sale,
      :"payment/sp2/credit/v1/credit" => :credit,
      :"payment/sp2/credit/v1/return" => :credit,
      :"payment/sp2/services/v1/paymentAccountCreate" => :registerTokenRequest,
      :"payment/sp2/credit/v1/void" => :void
    }.freeze

    def initialize(endpoint:, body:, response_object:, use_xml: false)
      @endpoint = endpoint
      @body = body
      @response_object = response_object
      @retry_count = 0
      @use_xml = use_xml

      if @use_xml
        body.card.payment_account_id = body.payment_account.id if body.card && body.payment_account

        body.transaction ||= Vantiv::Api::Transaction.new
        body.transaction.type = ENDPOINT_XML_TRANSACTION_TYPE.fetch(endpoint.to_sym)
        body.transaction.card = body.card if body.card
        body.transaction.report_group = body.report_group
        body.transaction.application_id = body.application_id

        body.xmlns = "http://www.litle.com/schema"
        body.version = "10.2"
      end
    end

    def run
      run_request_with_retries
    end

    def run_request
      if @use_xml
        http_response = make_xml_request
      else
        http_response = make_json_request
      end
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

    def make_xml_request
      http = Net::HTTP.new(xml_uri.host, xml_uri.port)
      http.use_ssl = true
      xml_request = Net::HTTP::Post.new(xml_uri.request_uri, xml_header)
      xml_request.body = body.to_xml
      http.request(xml_request)
    end

    def xml_header
      {
        "Content-Type" =>"text/xml"
      }
    end

    def xml_uri
      @uri ||= URI.parse("https://transact-prelive.litle.com/vap/communicator/online")
    end

    def populated_response(response, http_response)
      new_response = response.dup

      new_response.raw_body = http_response.body
      new_response.httpok = http_response.code_type == Net::HTTPOK
      new_response.http_response_code = http_response.code

      if @use_xml
        response_body = ResponseBodyRepresenterXml.new(
          Vantiv::Api::ResponseBody.new
        ).from_xml(http_response.body)
      else
        response_body = ResponseBodyRepresenter.new(
          Vantiv::Api::ResponseBody.new
        ).from_json(http_response.body)
      end

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
      rescue MultiJson::ParseError, Nokogiri::XML::SyntaxError => e
        increment_retry_count
        max_retries_exceeded? ? raise(e) : retry
      end
    end
  end
end
