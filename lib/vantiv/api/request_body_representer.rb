require 'representable/json'
require 'vantiv/api/card'
require 'vantiv/api/transaction'
require 'vantiv/api/payment_account'
require 'vantiv/api/address'

class RequestBodyRepresenter < Representable::Decorator
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

  property :transaction, as: :Transaction, class: Vantiv::Api::Transaction do
    property :id, as: :TransactionID
    property :order_id, as: :ReferenceNumber
    property :amount, as: :TransactionAmount
    property :order_source, as: :OrderSource
    property :customer_id, as: :CustomerID
    property :partial_approved_flag, as: :PartialApprovedFlag
  end

  property :card, as: :Card, class: Vantiv::Api::Card do
    property :card_number, as: :CardNumber
    property :account_number, as: :AccountNumber
    property :expiry_month, as: :ExpirationMonth
    property :expiry_year, as: :ExpirationYear
    property :cvv, as: :CVV
    property :type, as: :Type
    property :paypage_registration_id, as: :PaypageRegistrationID
  end

  property :payment_account, as: :PaymentAccount, class: Vantiv::Api::PaymentAccount do
    property :id, as: :PaymentAccountID
  end

  property :address, as: :Address, class: Vantiv::Api::Address do
    property :billing_name, as: :BillingName
    property :billing_address_1, as: :BillingAddress1
    property :billing_address_2, as: :BillingAddress2
    property :billing_city, as: :BillingCity
    property :billing_state, as: :BillingState
    property :billing_zipcode, as: :BillingZipcode
    property :billing_country, as: :BillingCountry
  end
end
