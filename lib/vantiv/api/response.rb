module Vantiv
  module Api
    class LitleTransactionResponse
      attr_accessor :message, :response_code, :transaction_id
    end

    class Response
      attr_reader :httpok, :http_response_code, :body, :response, :version, :fault

      attr_writer :message, :response_code, :response, :version, :httpok, :http_response_code

      attr_accessor :body_message

      attr_accessor :authorization_response, :sale_response, :credit_response, :void_response,
                    :auth_reversal_response, :capture_response, :register_token_response

      def load(httpok:, http_response_code:, body:)
        @httpok = httpok
        @http_response_code = http_response_code
        @body = body
      end

      # Only returned by cert API?
      def request_id
        body["RequestID"]
      end

      def api_level_failure?
        !httpok || litle_response_has_error?
      end

      def message
        litle_transaction_response.message if litle_transaction_response
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
        api_level_failure? ? nil: body.send(snake_case(transaction_response_name))
      end

      def snake_case(string)
        return string.downcase if string.match(/\A[A-Z]+\z/)
        string.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
            gsub(/([a-z])([A-Z])/, '\1_\2').
            downcase
      end
    end
  end
end
