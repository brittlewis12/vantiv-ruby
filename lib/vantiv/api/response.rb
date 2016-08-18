require "forwardable"

module Vantiv
  module Api
    class Response
      extend Forwardable

      attr_accessor :httpok, :http_response_code, :body, :raw_body

      def_delegators :litle_transaction_response, :message, :response_code, :transaction_id

      def api_level_failure?
        !httpok || litle_response_has_error?
      end

      def error_message
        api_level_failure? ? api_level_error_message : message
      end

      private

      def litle_response_has_error?
        # NOTE: this kind of sucks, but at the commit point, the DevHub
        #   Api sometimes gives 200OK when litle had a parse issue and returns
        #   'Error validating xml data...' instead of an actual error
        !!body.body_message.match(/error/i)
      end

      def api_level_error_message
        "API level error"
      end

      attr_reader :transaction_response_name

      def litle_transaction_response
        api_level_failure? ? TransactionResponse.new : body.send(transaction_response_name)
      end
    end
  end
end
