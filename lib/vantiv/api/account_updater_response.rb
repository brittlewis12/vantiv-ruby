require "forwardable"

module Vantiv
  module Api
    class CardTokenInfo
      attr_accessor :payment_account_id, :card_type, :expiry_month, :expiry_year, :bin
    end

    class ExtendedCardResponse
      attr_accessor :code, :message
    end

    class AccountUpdaterResponse
      extend Forwardable

      attr_accessor :original_card_token_info, :new_card_token_info, :extended_card_response

      def initialize
        @new_card_token_info = CardTokenInfo.new
        @extended_card_response = ExtendedCardResponse.new
      end

      def_delegators :new_card_token_info, :payment_account_id, :card_type, :expiry_month, :expiry_year

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
