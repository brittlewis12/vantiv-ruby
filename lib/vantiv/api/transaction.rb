module Vantiv
  module Api
    class Transaction
      attr_accessor :id, :order_id, :customer_id, :order_source, :partial_approved_flag
      attr_writer :amount
      def initialize(id: nil, amount_in_cents: nil, order_id: nil, order_source: nil, customer_id: nil, partial_approved_flag: nil)
        @id = id
        @amount_in_cents = amount_in_cents
        @order_id = order_id
        @order_source = order_source
        @customer_id = customer_id
        @partial_approved_flag = partial_approved_flag
      end

      def amount
        @amount ||= ('%.2f' % (@amount_in_cents / 100.0) if @amount_in_cents)
      end

      def order_id
        @order_id.to_s if @order_id
      end
    end
  end
end
