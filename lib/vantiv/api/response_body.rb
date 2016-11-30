module Vantiv
  module Api
    class ResponseBody
      attr_writer :message, :response_code

      attr_accessor *%i(
        body_message
        request_id
        response
        version
        auth_reversal_response
        authorization_response
        capture_response
        credit_response
        register_token_response
        sale_response
        void_response
      )
    end
  end
end
