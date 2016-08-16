require 'vantiv/api/response'
require 'vantiv/api/live_transaction_response'
require 'vantiv/mocked_sandbox/mocked_response_representer'

module Vantiv
  module MockedSandbox
    class ApiRequest
      class EndpointNotMocked < StandardError; end
      class FixtureNotFound < StandardError; end

      def self.run(endpoint:, body:, response_object:)
        new(endpoint, body, response_object).run
      end

      def initialize(endpoint, request_body, response_object)
        self.endpoint = endpoint
        self.request_body = JSON.parse(request_body)
        self.response_object = response_object
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
      end

      private

      attr_accessor :endpoint, :request_body, :fixture, :response_object

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
          self.fixture = File.open("#{MockedSandbox.fixtures_directory}#{fixture_file_name}.json", 'r') do |f|
            response = MockedResponseRepresenter.new(response_object).from_json(f.read)

            populated_dynamic_response(response)
          end
        rescue Errno::ENOENT
          raise FixtureNotFound.new("Fixture not found for api method: #{api_method}, card number or temporary token: #{card_number_or_temporary_token}")
        end
      end

      def populated_dynamic_response(response)
        dynamic_response = response.dup
        transaction_response = dynamic_response.send(:litle_transaction_response)

        transaction_response.report_group = Vantiv.default_report_group
        transaction_response.response_time = Time.now.strftime('%FT%T')
        transaction_response.transaction_id = rand(10**17)

        if transaction_response.post_date
          transaction_response.post_date = Time.now.strftime('%F')
        end
        dynamic_response
      end
    end
  end
end
