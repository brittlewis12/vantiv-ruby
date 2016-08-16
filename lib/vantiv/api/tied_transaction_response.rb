module Vantiv
  module Api
    class TiedTransactionResponse < Api::Response
      RESPONSE_CODES = {
        transaction_received: '001'
      }.freeze

      TIED_TRANSACTION_RESPONSE_NAMES = {
        auth_reversal: 'auth_reversal_response',
        capture: "capture_response",
        credit: "credit_response",
        return: "credit_response",
        void: "void_response"
      }

      def initialize(transaction_name)
        unless @transaction_response_name = TIED_TRANSACTION_RESPONSE_NAMES[transaction_name]
          raise "Implementation Error: Tied transactions do not include #{transaction_name}"
        end
      end

      def success?
        !api_level_failure? && response_code == RESPONSE_CODES[:transaction_received]
      end

      def failure?
        !success?
      end
    end
  end
end
