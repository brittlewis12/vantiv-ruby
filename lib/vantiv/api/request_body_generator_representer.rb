require 'representable/json'

class RequestBodyGeneratorRepresenter < Representable::Decorator
  include Representable::JSON

  nested :Credentials do
    property :acceptor_id, as: :AcceptorID
  end

  nested :Reports do
    property :report_group, as: :ReportGroup
  end

  nested :Application do
    property :application_id, as: :ApplicationID
  end

  property :card, as: :Card do
    property :card_number, as: :AccountNumber
    property :expiry_month, as: :ExpirationMonth
    property :expiry_year, as: :ExpirationYear
    property :cvv, as: :CVV
    property :paypage_registration_id, as: :PaypageRegistrationID
  end

  property :transaction, as: :Transaction do
    property :id, as: :TransactionID
    property :amount, as: :TransactionAmount
    property :order_id, as: :ReferenceNumber
    property :customer_id, as: :CustomerID
    property :order_source, as: :OrderSource
    property :partial_approved_flag, as: :PartialApprovedFlag
  end

  property :payment_account, as: :PaymentAccount do
    property :id, as: :PaymentAccountID
  end
end
