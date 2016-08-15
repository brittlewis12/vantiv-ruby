module Vantiv
  module Api
    class ResponseBody
      attr_reader :fault

      attr_writer :message, :response_code

      attr_accessor :body_message, :response, :version, :request_id

      attr_accessor :authorization_response, :sale_response, :credit_response, :void_response,
                    :auth_reversal_response, :capture_response, :register_token_response
    end
  end
end
