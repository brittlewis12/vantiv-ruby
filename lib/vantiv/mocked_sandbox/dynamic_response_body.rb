require 'vantiv/api/response_representer'

module Vantiv
  module MockedSandbox
    class DynamicResponseBody
      def self.generate(body:, litle_txn_name:, mocked_payment_account_id: nil)
        new(body, litle_txn_name, mocked_payment_account_id).run
      end

      def initialize(body, litle_txn_name, mocked_payment_account_id)
        @body = body
        @litle_txn_name = litle_txn_name
        @mocked_payment_account_id = mocked_payment_account_id
      end

      def run
        litle_transaction_response.report_group = "<%= Vantiv.default_report_group %>"
        litle_transaction_response.response_time = "<%= Time.now.strftime('%FT%T') %>"
        litle_transaction_response.transaction_id = "<%= rand(10**17) %>"

        if litle_transaction_response.payment_account_id
          litle_transaction_response.payment_account_id = mocked_payment_account_id
        end

        if litle_transaction_response.post_date
          litle_transaction_response.post_date = "<%= Time.now.strftime('%F') %>"
        end
        ResponseRepresenter.new(dynamic_body).to_hash
      end

      private

      attr_reader :body, :litle_txn_name, :mocked_payment_account_id

      def litle_transaction_response
        dynamic_body.send(snake_case(litle_txn_name))
      end

      def dynamic_body
        @dynamic_body ||= body.dup
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
