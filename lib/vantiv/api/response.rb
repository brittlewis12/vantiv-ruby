module Vantiv
  module Api
    class Response
      attr_accessor :httpok, :http_response_code, :body

      def load(httpok:, http_response_code:, body:)
        @httpok = httpok
        @http_response_code = http_response_code
        @body = body
      end

      def api_level_failure?
        !httpok || litle_response_has_error?
      end

      def message
        litle_transaction_response.message
      end

      def error_message
        api_level_failure? ? api_level_error_message : message
      end

      def response_code
        litle_transaction_response.response_code
      end

      def transaction_id
        litle_transaction_response.transaction_id
      end

      private

      def litle_response_has_error?
        # NOTE: this kind of sucks, but at the commit point, the DevHub
        #   Api sometimes gives 200OK when litle had a parse issue and returns
        #   'Error validating xml data...' instead of an actual error
        !!body.body_message.match(/error/i)
      end

      def api_level_error_message
        body["errormsg"]
      end

      attr_reader :transaction_response_name

      def litle_response
        api_level_failure? ? {} : body["litleOnlineResponse"]
      end

      def litle_transaction_response
        api_level_failure? ? TransactionResponse.new : body.send(transaction_response_name)
      end
    end
  end
end
