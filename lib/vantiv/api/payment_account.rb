module Vantiv
  module Api
    class PaymentAccount
      attr_reader :id

      def initialize(id:)
        @id = id
      end
    end
  end
end
