require "forwardable"

module Vantiv
  module Api
    class TokenizationResponse < Api::Response
      extend Forwardable

      RESPONSE_CODES = {
        account_successfully_registered: '801',
        account_already_registered: '802',
        credit_card_number_invalid: '820',
        merchant_not_authorized_for_tokens: '821',
        token_not_found: '822',
        token_invalid: '823',
        invalid_paypage_registration_id: '877',
        expired_paypage_registration_id: '878',
        generic_token_registration_error: '898',
        generic_token_use_error: '899'
      }.freeze

      def_delegators :litle_transaction_response, :payment_account_id

      def card_type
        litle_transaction_response.type
      end

      def success?
        !api_level_failure? && tokenization_successful?
      end

      def failure?
        !success?
      end

      def invalid_card_number?
        response_code == RESPONSE_CODES[:credit_card_number_invalid]
      end

      def apple_pay
        @apple_pay ||=
          litle_transaction_response.apple_pay_response || ApplePayResponse.new
      end
      private

      def tokenization_successful?
        response_code == RESPONSE_CODES[:account_successfully_registered] ||
          response_code == RESPONSE_CODES[:account_already_registered]
      end

      def transaction_response_name
        "register_token_response"
      end
    end
  end
end
