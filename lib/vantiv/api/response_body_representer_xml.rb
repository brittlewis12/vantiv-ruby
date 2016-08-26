require 'representable/xml'
require 'vantiv/api/transaction_response_representer_xml'
require 'vantiv/api/response'

class ResponseBodyRepresenterXml < Representable::Decorator
  include Representable::XML

  self.representation_wrap= :litleOnlineResponse
  remove_namespaces!

  property :body_message, as: :@message
  property :response, as: :@response
  property :version, as: :@version

  property :authorization_response, as: :authorizationResponse, decorator: TransactionResponseRepresenterXml, class: Vantiv::Api::TransactionResponse
  property :sale_response, as: :saleResponse, decorator: TransactionResponseRepresenterXml, class: Vantiv::Api::TransactionResponse
  property :credit_response, as: :creditResponse, decorator: TransactionResponseRepresenterXml, class: Vantiv::Api::TransactionResponse
  property :void_response, as: :voidResponse, decorator: TransactionResponseRepresenterXml, class: Vantiv::Api::TransactionResponse
  property :auth_reversal_response, as: :authReversalResponse, decorator: TransactionResponseRepresenterXml, class: Vantiv::Api::TransactionResponse
  property :capture_response, as: :captureResponse, decorator: TransactionResponseRepresenterXml, class: Vantiv::Api::TransactionResponse

  property :register_token_response, as: :registerTokenResponse, decorator: TransactionResponseRepresenterXml, class: Vantiv::Api::TransactionResponse


  property :request_id, as: :RequestID
end
