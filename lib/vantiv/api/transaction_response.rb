module Vantiv
  module Api
    class TransactionResponse
      attr_accessor *%i(
        account_updater
        apple_pay_response
        auth_code
        bin
        customer_id
        fraud_result
        id
        message
        network_transaction_id
        order_id
        payment_account_id
        post_date
        report_group
        response_code
        response_time
        token_message
        token_response
        token_response_code
        transaction_id
        type
      )
    end
  end
end
