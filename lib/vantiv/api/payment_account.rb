module Vantiv
  module Api
    class PaymentAccount
      attr_accessor :id

      def initialize(id: nil)
        @id = id
      end
    end
  end
end
