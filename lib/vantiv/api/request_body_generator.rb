require 'securerandom'

module Vantiv
  module Api
    class Card < OpenStruct; end
    class Transaction < OpenStruct; end
    class PaymentAccount < OpenStruct; end

    class RequestBodyGenerator
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
        ::RequestBodyGeneratorRepresenter.new(self).to_hash
      end
    end
  end
end
