require 'representable/json'
require 'vantiv/api/transaction_response_representer'

class ResponseRepresenter < Representable::Decorator
  include Representable::JSON
  self.representation_wrap= :litleOnlineResponse

  property :message, as: :@message
  property :response, as: :@response
  property :version, as: :@version

  property :authorization_response, as: :authorizationResponse, decorator: TransactionResponseRepresenter, class: OpenStruct
  property :sale_response, as: :saleResponse, decorator: TransactionResponseRepresenter, class: OpenStruct
  property :auth_reversal_response, as: :authReversalResponse, decorator: TransactionResponseRepresenter, class: OpenStruct
  property :capture_response, as: :captureResponse, decorator: TransactionResponseRepresenter, class: OpenStruct
  property :register_token_response, as: :registerTokenResponse, decorator: TransactionResponseRepresenter, class: OpenStruct

  property :fault, class: OpenStruct do
    property :faultstring
    property :detail do
      property :errorcode
    end
  end
end
