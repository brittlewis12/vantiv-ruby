module Vantiv
  module Api
    class TransactionResponse
      attr_accessor :message, :response_code, :transaction_id, :response_time, :id, :report_group, :payment_account_id,
                    :post_date, :type, :bin, :auth_code, :customer_id, :order_id, :token_response_code, :token_message,
                    :fraud_result, :account_updater
    end

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
        api_level_failure? ? TransactionResponse.new : body.send(snake_case(transaction_response_name))
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
