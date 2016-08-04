module Vantiv
  module Api
    module RequestBody
      def self.for_auth_or_sale(amount:, customer_id:, order_id:, payment_account_id:, expiry_month:, expiry_year:)
        transaction = transaction_element(
          amount: amount,
          order_id: order_id,
          customer_id: customer_id
        )
        card = Card.new(
          expiry_month: expiry_month,
          expiry_year: expiry_year
        )
        payment_account = PaymentAccount.new(id: payment_account_id)

        RequestBodyGenerator.new(
          transaction: transaction,
          card: card,
          payment_account: payment_account
        ).run
      end

      def self.for_auth_reversal(transaction_id:, amount: nil)
        transaction = tied_transaction_element(transaction_id: transaction_id, amount: amount)
        RequestBodyGenerator.new(transaction: transaction).run
      end

      def self.for_capture(transaction_id:, amount: nil)
        transaction = tied_transaction_element(transaction_id: transaction_id, amount: amount)
        RequestBodyGenerator.new(transaction: transaction).run
      end

      def self.for_credit(transaction_id:, amount: nil)
        transaction = tied_transaction_element(transaction_id: transaction_id, amount: amount)
        RequestBodyGenerator.new(transaction: transaction).run
      end

      def self.for_return(amount:, customer_id:, order_id:, payment_account_id:, expiry_month:, expiry_year:)
        transaction = Transaction.new(
          order_id: order_id,
          amount_in_cents: amount,
          order_source: Vantiv.order_source,
          customer_id: customer_id
        )
        card = Card.new(
          expiry_month: expiry_month,
          expiry_year: expiry_year
        )
        payment_account = PaymentAccount.new(id: payment_account_id)

        RequestBodyGenerator.new(
          transaction: transaction,
          card: card,
          payment_account: payment_account
        ).run
      end

      def self.for_tokenization(paypage_registration_id:)
        card = Card.new(paypage_registration_id: paypage_registration_id)
        RequestBodyGenerator.new(card: card).run
      end

      def self.for_direct_post_tokenization(card_number:, expiry_month:, expiry_year:, cvv:)
        card = Card.new(
          card_number: card_number.to_s.gsub(/\D*/, ""),
          expiry_month: expiry_month,
          expiry_year: expiry_year,
          cvv: cvv.to_s
        )
        RequestBodyGenerator.new(card: card).run
      end

      def self.for_void(transaction_id:)
        transaction = Transaction.new(id: transaction_id)
        RequestBodyGenerator.new(transaction: transaction).run
      end

      def self.tied_transaction_element(transaction_id:, amount: nil)
        Transaction.new(
          id: transaction_id,
          amount_in_cents: amount
        )
      end

      def self.transaction_element(amount:, customer_id:, order_id:)
        Transaction.new(
         order_id: order_id,
         amount_in_cents: amount,
         order_source: Vantiv.order_source,
         customer_id: customer_id,
         partial_approved_flag: false
        )
      end
    end
  end
end
