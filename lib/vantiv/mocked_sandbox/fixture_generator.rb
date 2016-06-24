require 'vantiv/mocked_sandbox/dynamic_response_body'
require 'vantiv/certification/paypage_driver'
require 'vantiv/test_paypage_registration_id'

module Vantiv
  module MockedSandbox
    class FixtureGenerator

      def self.generate_all
        new.run
      end

      attr_accessor :card

      def run
        @paypage_driver = Vantiv::Certification::PaypageDriver.new
        @paypage_driver.start
        record_tokenize

        TestCard.all.each do |card|
          self.card = CardforFixtureGeneration.new(card)

          record_tokenize_by_direct_post
          if card.tokenizable?
            record_auth_capture
            record_auth
            record_refund
          end
        end

        @paypage_driver.stop

        record_capture
        record_auth_reversal
        record_credit
        record_void
      end

      private

      def record_tokenize
        record_valid_tokenize
        record_expired_tokenize
      end

      def record_expired_tokenize
        test_paypage_id = TestPaypageRegistrationId.expired_registration_id
        cert_response = Vantiv.tokenize(
          temporary_token: test_paypage_id.mocked_sandbox_paypage_registration_id
        )
        dynamic_body = DynamicResponseBody.generate(
          body: cert_response.body,
          litle_txn_name: "registerTokenResponse",
        )
        write_fixture_to_file(
          "tokenize--#{test_paypage_id.mocked_sandbox_paypage_registration_id}",
          cert_response,
          dynamic_body
        )
      end

      def record_valid_tokenize
        test_paypage_id = TestPaypageRegistrationId.valid_registration_id
        cert_response = Vantiv.tokenize(
          temporary_token: generate_real_registration_id(test_paypage_id.test_card)
        )
        dynamic_body = DynamicResponseBody.generate(
          body: cert_response.body,
          litle_txn_name: "registerTokenResponse",
          mocked_payment_account_id: test_paypage_id.test_card.mocked_sandbox_payment_account_id
        )
        write_fixture_to_file(
          "tokenize--#{test_paypage_id.mocked_sandbox_paypage_registration_id}",
          cert_response,
          dynamic_body
        )
      end

      def generate_real_registration_id(card)
        @paypage_driver.get_paypage_registration_id(
          card.card_number,
          card.cvv
        )
      end

      def record_tokenize_by_direct_post
        cert_response = Vantiv.tokenize_by_direct_post(
          card_number: card.card_number,
          expiry_month: card.expiry_month,
          expiry_year: card.expiry_year,
          cvv: card.cvv
        )
        dynamic_body = DynamicResponseBody.generate(
          body: cert_response.body,
          litle_txn_name: "registerTokenResponse",
          mocked_payment_account_id: card.mocked_sandbox_payment_account_id
        )
        write_fixture_to_file("tokenize_by_direct_post--#{card.card_number}", cert_response, dynamic_body)
      end

      def record_auth_capture
        cert_response = Vantiv.auth_capture(
          amount: 10901,
          payment_account_id: card.payment_account_id,
          expiry_month: card.expiry_month,
          expiry_year: card.expiry_year,
          customer_id: "not-dynamic-cust-id",
          order_id: "not-dynamic-order-id"
        )
        dynamic_body = DynamicResponseBody.generate(
          body: cert_response.body,
          litle_txn_name: "saleResponse"
        )
        write_fixture_to_file("auth_capture--#{card.card_number}", cert_response, dynamic_body)
      end

      def record_auth
        cert_response = Vantiv.auth(
          amount: 10901,
          payment_account_id: card.payment_account_id,
          expiry_month: card.expiry_month,
          expiry_year: card.expiry_year,
          customer_id: "not-dynamic-cust-id",
          order_id: "not-dynamic-order-id"
        )
        dynamic_body = DynamicResponseBody.generate(
          body: cert_response.body,
          litle_txn_name: "authorizationResponse"
        )
        write_fixture_to_file("auth--#{card.card_number}", cert_response, dynamic_body)
      end

      def record_refund
        cert_response = Vantiv.refund(
          amount: 10901,
          payment_account_id: card.payment_account_id,
          expiry_month: card.expiry_month,
          expiry_year: card.expiry_year,
          customer_id: "not-dynamic-cust-id",
          order_id: "not-dynamic-order-id"
        )
        dynamic_body = DynamicResponseBody.generate(
          body: cert_response.body,
          litle_txn_name: "creditResponse"
        )
        write_fixture_to_file("refund--#{card.card_number}", cert_response, dynamic_body)
      end

      def record_capture
        cert_response = Vantiv.capture(
          transaction_id: rand(10**17).to_s
        )
        dynamic_body = DynamicResponseBody.generate(
          body: cert_response.body,
          litle_txn_name: "captureResponse"
        )
        write_fixture_to_file("capture", cert_response, dynamic_body)
      end

      def record_auth_reversal
        cert_response = Vantiv.auth_reversal(
          transaction_id: rand(10**17).to_s
        )
        dynamic_body = DynamicResponseBody.generate(
          body: cert_response.body,
          litle_txn_name: "authReversalResponse"
        )
        write_fixture_to_file("auth_reversal", cert_response, dynamic_body)
      end

      def record_credit
        cert_response = Vantiv.credit(
          transaction_id: rand(10**17).to_s,
          amount: 1010
        )
        dynamic_body = DynamicResponseBody.generate(
          body: cert_response.body,
          litle_txn_name: "creditResponse"
        )
        write_fixture_to_file("credit", cert_response, dynamic_body)
      end

      def record_void
        cert_response = Vantiv.void(
          transaction_id: rand(10**17).to_s
        )
        dynamic_body = DynamicResponseBody.generate(
          body: cert_response.body,
          litle_txn_name: "voidResponse"
        )
        write_fixture_to_file("void", cert_response, dynamic_body)
      end

      def write_fixture_to_file(file_name, response, dynamic_body)
        File.open("#{MockedSandbox.fixtures_directory}/#{file_name}.json.erb", 'w') do |fixture|
          fixture << JSON.pretty_generate({
            httpok: response.httpok,
            http_response_code: response.http_response_code,
            response_body: dynamic_body
          })
        end
      end
    end

    # The similarities between this and Vantiv::TestAccount are too great.
    #   They ought to be cleaned up and merged
    class CardforFixtureGeneration

      def initialize(card)
        @card = card
      end

      def payment_account_id
        @payment_account_id ||= get_payment_account_id
      end

      def card_number
        card.card_number
      end

      def expiry_month
        card.expiry_month
      end

      def expiry_year
        card.expiry_year
      end

      def cvv
        card.cvv
      end

      def mocked_sandbox_payment_account_id
        card.mocked_sandbox_payment_account_id
      end

      private

      attr_reader :card

      def get_payment_account_id(attempts=0)
        tokenization = Vantiv.tokenize_by_direct_post(
          card_number: card.card_number,
          expiry_month: card.expiry_month,
          expiry_year: card.expiry_year,
          cvv: card.cvv
        )
        if tokenization.success?
          tokenization.payment_account_id
        elsif attempts < 3
          attempts += 1
          get_payment_account_id(attempts)
        else
          raise "Tried and failed to get payment account id"
        end
      end
    end
  end
end
