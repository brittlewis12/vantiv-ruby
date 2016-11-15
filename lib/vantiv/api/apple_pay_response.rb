module Vantiv
  module Api
    class ApplePayResponse
      attr_accessor :online_payment_cryptogram
      # if online_payment_cryptogram is present you must pass
      # it in the next auth or sale transaction
    end
  end
end
