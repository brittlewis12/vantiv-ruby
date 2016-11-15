module Vantiv
  module Api
    class CardholderAuthentication
      attr_accessor :authentication_value

      def initialize(authentication_value:)
        @authentication_value = authentication_value
      end
    end
  end
end
