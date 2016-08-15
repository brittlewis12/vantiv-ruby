require 'representable/json'
require 'vantiv/api/transaction_response_representer'
require 'vantiv/api/response'

class ResponseBodyRepresenter < Representable::Decorator
  include Representable::JSON
  self.representation_wrap= :litleOnlineResponse

  property :body_message, as: :@message
  property :response, as: :@response
  property :version, as: :@version

  property :authorization_response, as: :authorizationResponse, decorator: TransactionResponseRepresenter, class: Vantiv::Api::TransactionResponse
  property :sale_response, as: :saleResponse, decorator: TransactionResponseRepresenter, class: Vantiv::Api::TransactionResponse
  property :credit_response, as: :creditResponse, decorator: TransactionResponseRepresenter, class: Vantiv::Api::TransactionResponse
  property :void_response, as: :voidResponse, decorator: TransactionResponseRepresenter, class: Vantiv::Api::TransactionResponse
  property :auth_reversal_response, as: :authReversalResponse, decorator: TransactionResponseRepresenter, class: Vantiv::Api::TransactionResponse
  property :capture_response, as: :captureResponse, decorator: TransactionResponseRepresenter, class: Vantiv::Api::TransactionResponse
  property :register_token_response, as: :registerTokenResponse, decorator: TransactionResponseRepresenter, class: Vantiv::Api::TransactionResponse

  property :fault, class: OpenStruct do
    property :faultstring
    property :detail do
      property :errorcode
    end
  end
end
