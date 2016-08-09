module Vantiv
  module Api
    class CardTokenInfo
      attr_accessor :payment_account_id, :card_type, :expiry_month, :expiry_year
    end

    class ExtendedCardResponse
      attr_accessor :code, :message
    end

    class AccountUpdaterResponse
      attr_accessor :new_card_token_info, :extended_card_response

      def initialize
        @new_card_token_info = CardTokenInfo.new
        @extended_card_response = ExtendedCardResponse.new
      end

      def payment_account_id
        new_card_token_info.payment_account_id
      end

      def card_type
        new_card_token_info.card_type
      end

      def expiry_month
        new_card_token_info.expiry_month
      end

      def expiry_year
        new_card_token_info.expiry_year
      end

      def extended_card_response_code
        extended_card_response.code
      end

      def extended_card_response_message
        extended_card_response.message
      end

      def new_card_token?
        !!payment_account_id
      end

      def extended_card_response?
        !!extended_card_response_code || !!extended_card_response_message
      end
    end
  end
end
