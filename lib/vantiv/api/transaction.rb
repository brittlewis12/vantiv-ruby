module Vantiv
  module Api
    class Transaction
      attr_accessor :id, :order_id, :customer_id, :order_source, :partial_approved_flag,
                    :amount_in_cents, :report_group, :card, :type, :application_id, :address

      def initialize(id: nil, amount_in_cents: nil, order_id: nil, order_source: nil, customer_id: nil, partial_approved_flag: nil)
        @id = id
        @amount_in_cents = amount_in_cents
        @order_id = order_id
        @order_source = order_source
        @customer_id = customer_id
        @partial_approved_flag = partial_approved_flag
      end

      def amount
        format_cents_to_decimal(@amount_in_cents) if @amount_in_cents
      end

      def amount=(value)
        @amount_in_cents = decimal_string_to_cents(value)
      end

      def order_id
        @order_id.to_s if @order_id
      end

      private

      def decimal_string_to_cents(string)
        (string.to_f * 100.0).to_i
      end

      def format_cents_to_decimal(cents)
        '%.2f' % (cents / 100.0)
      end
    end
  end
end
