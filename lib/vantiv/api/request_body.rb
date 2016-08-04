require 'securerandom'

module Vantiv
  module Api
    class RequestBody
      attr_reader :acceptor_id, :application_id, :report_group, :card, :transaction, :payment_account

      def initialize(card: nil, transaction: nil, payment_account: nil)
        @card = card
        @transaction = transaction
        @payment_account = payment_account

        @acceptor_id = Vantiv.acceptor_id
        @application_id = SecureRandom.hex(12)
        @report_group = Vantiv.default_report_group
      end

      def run
        ::RequestBodyRepresenter.new(self).to_hash
      end

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

        new(
          transaction: transaction,
          card: card,
          payment_account: payment_account
        ).run
      end

      def self.for_auth_reversal(transaction_id:, amount: nil)
        transaction = Transaction.new(id: transaction_id, amount_in_cents: amount)
        new(transaction: transaction).run
      end

      def self.for_capture(transaction_id:, amount: nil)
        transaction = Transaction.new(id: transaction_id, amount_in_cents: amount)
        new(transaction: transaction).run
      end

      def self.for_credit(transaction_id:, amount: nil)
        transaction = Transaction.new(id: transaction_id, amount_in_cents: amount)
        new(transaction: transaction).run
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

        new(
          transaction: transaction,
          card: card,
          payment_account: payment_account
        ).run
      end

      def self.for_tokenization(paypage_registration_id:)
        card = Card.new(paypage_registration_id: paypage_registration_id)
        new(card: card).run
      end

      def self.for_direct_post_tokenization(card_number:, expiry_month:, expiry_year:, cvv:)
        card = Card.new(
          card_number: card_number,
          expiry_month: expiry_month,
          expiry_year: expiry_year,
          cvv: cvv
        )
        new(card: card).run
      end

      def self.for_void(transaction_id:)
        transaction = Transaction.new(id: transaction_id)
        new(transaction: transaction).run
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
