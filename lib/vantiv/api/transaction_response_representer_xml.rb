require 'representable/xml'
require 'ostruct'
require 'vantiv/api/account_updater_response'

class TransactionResponseRepresenterXml < Representable::Decorator
  include Representable::XML

  property :id, as: :id, property: true
  property :report_group, as: :reportGroup, property: true
  property :customer_id, as: :customerId, property: true

  property :transaction_id, as: :litleTxnId
  property :payment_account_id, as: :litleToken
  property :order_id, as: :orderId
  property :response_code, as: :response
  property :response_time, as: :responseTime
  property :message
  property :auth_code, as: :authCode
  property :type, as: :type

  property :account_updater, as: :accountUpdater, class: Vantiv::Api::AccountUpdaterResponse do
    property :original_card_token_info, as: :originalCardTokenInfo, class: Vantiv::Api::CardTokenInfo do
      property :payment_account_id, as: :litleToken
      property :card_type, as: :type
      property :bin
      property :expiry_date, as: :expDate
    end

    property :new_card_token_info, as: :newCardTokenInfo, class: Vantiv::Api::CardTokenInfo do
      property :payment_account_id, as: :litleToken
      property :card_type, as: :type
      property :bin
      property :expiry_date, as: :expDate
    end

    property :extended_card_response, as: :extendedCardResponse, class: Vantiv::Api::ExtendedCardResponse do
      property :code
      property :message
    end
  end

  property :fraud_result, as: :fraudResult, class: OpenStruct do
    property :avs_result, as: :avsResult
  end

end
