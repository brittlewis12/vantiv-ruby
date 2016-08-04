module Vantiv
  module Api
    class Transaction
      attr_reader :id, :reference_number, :customer_id, :order_source, :partial_approved_flag

      def initialize(id: nil, amount_in_cents: nil, reference_number: nil, order_source: nil, customer_id: nil, partial_approved_flag: nil)
        @id = id
        @amount_in_cents = amount_in_cents
        @reference_number = reference_number
        @order_source = order_source
        @customer_id = customer_id
        @partial_approved_flag = partial_approved_flag
      end

      def amount
        '%.2f' % (@amount_in_cents / 100.0) if @amount_in_cents
      end
    end
  end
end
