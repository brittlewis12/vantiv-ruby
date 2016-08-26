module Vantiv
  module Api
    class Card
      attr_writer :cvv, :card_number, :account_number
      attr_accessor :expiry_month, :expiry_year, :type, :paypage_registration_id, :payment_account_id

      def initialize(expiry_month: nil, expiry_year: nil, cvv: nil, card_number: nil, account_number: nil, paypage_registration_id: nil)
        @expiry_month = expiry_month
        @expiry_year = expiry_year
        @cvv = cvv
        @card_number = card_number
        @account_number = account_number
        @paypage_registration_id = paypage_registration_id
      end

      def expiry_month
        format_expiry(@expiry_month) if @expiry_month
      end

      def expiry_year
        format_expiry(@expiry_year) if @expiry_year
      end

      def card_number
        format_card_number(@card_number) if @card_number
      end

      def account_number
        format_card_number(@account_number) if @account_number
      end

      def cvv
        @cvv.to_s if @cvv
      end

      private

      def format_expiry(raw_value)
        raw_value.to_s.reverse[0..1].reverse.rjust(2, "0")
      end

      def format_card_number(card_number)
        card_number.to_s.gsub(/\D*/, "") if card_number
      end
    end
  end
end
