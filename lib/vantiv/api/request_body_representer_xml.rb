require 'vantiv/api/transaction'
require 'vantiv/api/request_body'
require 'vantiv/api/transaction_request_representer_xml'

class RequestBodyRepresenterXml < Representable::Decorator
  include Representable::XML
  self.representation_wrap = :litleOnlineRequest

  property :version, attribute: true
  property :xmlns, attribute: true
  property :acceptor_id, as: :merchantId, attribute: true

  property :authentication, class: Vantiv::Api::Authentication, as: :authentication do
    property :user
    property :password
  end

  property :transaction, class: Vantiv::Api::Transaction, decorator: TransactionRequestRepresenterXml
end
