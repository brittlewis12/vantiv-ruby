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
      @response_object = response_object
      @retry_count = 0
      @use_xml = use_xml

      if @use_xml
        @body = populated_xml_request_body(body)
      else
        @body = body
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

    def populated_xml_request_body(body)
      populated_body = body.dup

      if populated_body.card && populated_body.payment_account
        populated_body.card.payment_account_id = populated_body.payment_account.id
      end

      populated_body.transaction ||= Vantiv::Api::Transaction.new
      populated_body.transaction.type = ENDPOINT_XML_TRANSACTION_TYPE.fetch(@endpoint.to_sym)
      populated_body.transaction.card = populated_body.card if populated_body.card
      populated_body.transaction.report_group = populated_body.report_group
      populated_body.transaction.application_id = populated_body.application_id

      populated_body.xmlns = "http://www.litle.com/schema"
      populated_body.version = "10.2"

      populated_body
    end

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
      @uri ||= URI.parse("#{xml_root_uri}/vap/communicator/online")
    end

    def xml_root_uri
      if Vantiv::Environment.production?
        "https://transact.litle.com"
      elsif Vantiv::Environment.certification?
        "https://transact-prelive.litle.com"
      end
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
