module Vantiv
  module Api
    class AccountUpdaterResponse
      def initialize(account_updater)
        @account_updater_response = account_updater
      end

      def payment_account_id
        new_card_token_info["PaymentAccountID"]
      end

      def card_type
        new_card_token_info["Type"]
      end

      def expiry_month
        new_card_token_info["ExpirationMonth"]
      end

      def expiry_year
        new_card_token_info["ExpirationYear"]
      end

      def extended_card_response_code
        extended_card_response["code"]
      end

      def extended_card_response_message
        extended_card_response["message"]
      end

      def new_card_token?
        new_card_token_info.any?
      end

      def extended_card_response?
        extended_card_response.any?
      end

      private
      attr_reader :account_updater_response

      def new_card_token_info
        account_updater_response.fetch("newCardTokenInfo", {})
      end

      def extended_card_response
        account_updater_response.fetch("extendedCardResponse", {})
      end
    end
  end
end
