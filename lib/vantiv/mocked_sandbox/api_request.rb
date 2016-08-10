require 'vantiv/api/response_representer'
require 'vantiv/api/response'

module Vantiv
  module MockedSandbox
    class ApiRequest
      class EndpointNotMocked < StandardError; end
      class FixtureNotFound < StandardError; end

      def self.run(endpoint:, body:)
        new(endpoint, body).run
      end

      def initialize(endpoint, request_body)
        self.endpoint = endpoint
        self.request_body = JSON.parse(request_body)
      end

      def run
        if endpoint == Api::Endpoints::TOKENIZATION
          if direct_post?
            load_fixture("tokenize_by_direct_post", card_number)
          else
            load_fixture("tokenize", temporary_token)
          end
        elsif endpoint == Api::Endpoints::SALE
          load_fixture("auth_capture", card_number_from_payment_account_id)
        elsif endpoint == Api::Endpoints::AUTHORIZATION
          load_fixture("auth", card_number_from_payment_account_id)
        elsif endpoint == Api::Endpoints::CAPTURE
          load_fixture("capture")
        elsif endpoint == Api::Endpoints::AUTH_REVERSAL
          load_fixture("auth_reversal")
        elsif endpoint == Api::Endpoints::CREDIT
          load_fixture("credit")
        elsif endpoint == Api::Endpoints::RETURN
          load_fixture("refund", card_number_from_payment_account_id)
        elsif endpoint == Api::Endpoints::VOID
          load_fixture("void")
        else
          raise EndpointNotMocked.new("#{endpoint} is not mocked!")
        end
        {
          httpok: fixture.httpok,
          http_response_code: fixture.http_response_code,
          body: fixture
        }
      end

      private

      attr_accessor :endpoint, :request_body, :fixture

      def direct_post?
        request_body["Card"] && request_body["Card"]["AccountNumber"] != nil
      end

      def temporary_token
        request_body["Card"]["PaypageRegistrationID"]
      end

      def card_number
        request_body["Card"]["AccountNumber"]
      end

      def card_number_from_payment_account_id
        TestCard.find_by_payment_account_id(
          request_body["PaymentAccount"]["PaymentAccountID"]
        ).card_number
      end

      def load_fixture(api_method, card_number_or_temporary_token = nil)
        fixture_file_name = card_number_or_temporary_token ? "#{api_method}--#{card_number_or_temporary_token}" : api_method
        begin
          self.fixture = File.open("#{MockedSandbox.fixtures_directory}#{fixture_file_name}.json.erb", 'r') do |f|
            raw_fixture = JSON.parse(f.read)
            # Prevent rails overridden version of to_json from encoding erb sepcial characters
            raw_fixture["response_body"] = JSON::Ext::Generator::GeneratorMethods::Hash
              .instance_method(:to_json)
              .bind(raw_fixture["response_body"])
              .call
            response = Vantiv::Api::Response.new
            response = ResponseRepresenter.new(response).from_json(ERB.new(raw_fixture["response_body"]).result(binding))
            response.httpok = raw_fixture["httpok"]
            response.http_response_code = raw_fixture["http_response_code"]
            response
          end
        rescue Errno::ENOENT
          raise FixtureNotFound.new("Fixture not found for api method: #{api_method}, card number or temporary token: #{card_number_or_temporary_token}")
        end
      end
    end
  end
end
