module Vantiv
  module Api
    class TransactionResponse
      attr_accessor :message, :response_code, :transaction_id, :response_time, :id, :report_group, :payment_account_id,
                    :post_date, :type, :bin, :auth_code, :customer_id, :order_id, :token_response_code, :token_message,
                    :fraud_result, :account_updater, :token_response, :apple_pay_response
    end
  end
end
