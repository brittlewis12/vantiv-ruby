require 'securerandom'

module Vantiv
  module Api
    class RequestBodyA < OpenStruct; end
    class Card < OpenStruct; end
    class Transaction < OpenStruct; end
    class PaymentAccount < OpenStruct; end

    class RequestBodyGenerator
      def initialize(card: nil, transaction: nil, payment_account: nil)
        @card = card
        @transaction = transaction
        @payment_account = payment_account
      end

      def run
        request_body = RequestBodyA.new(
          acceptor_id: Vantiv.acceptor_id,
          application_id: SecureRandom.hex(12),
          report_group: Vantiv.default_report_group,
          card: @card,
          transaction: @transaction,
          payment_account: @payment_account
        )

        ::RequestBodyGeneratorRepresenter.new(request_body).to_hash
      end
    end
  end
end
