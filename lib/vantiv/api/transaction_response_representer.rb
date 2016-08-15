require 'representable/json'
require 'ostruct'
require 'vantiv/api/account_updater_response'

class TransactionResponseRepresenter < Representable::Decorator
  include Representable::JSON

  property :auth_code, as: :authCode
  property :customer_id, as: :@customerId
  property :order_id, as: :orderId

  property :response_code, as: :response
  property :response_time, as: :responseTime
  property :post_date, as: :postDate
  property :id, as: :@id

  property :fraud_result, as: :fraudResult, class: OpenStruct do
    property :avs_result, as: :avsResult
    property :card_validation_result, as: :cardValidationResult
  end

  property :message
  property :report_group, as: :@reportGroup
  property :transaction_id, as: :TransactionID

  property :token_response_code, as: :tokenResponseCode
  property :token_message, as: :tokenMessage
  property :type, as: :Type
  property :bin
  property :payment_account_id, as: :PaymentAccountID

  property :account_updater, as: :accountUpdater, class: Vantiv::Api::AccountUpdaterResponse do
    property :original_card_token_info, as: :originalCardTokenInfo, class: Vantiv::Api::CardTokenInfo do
      property :bin
      property :card_type, as: :Type
      property :payment_account_id, as: :PaymentAccountID
      property :expiry_month, as: :ExpirationMonth
      property :expiry_year, as: :ExpirationYear
    end

    property :new_card_token_info, as: :newCardTokenInfo, class: Vantiv::Api::CardTokenInfo do
      property :bin
      property :card_type, as: :Type
      property :payment_account_id, as: :PaymentAccountID
      property :expiry_month, as: :ExpirationMonth
      property :expiry_year, as: :ExpirationYear
    end

    property :extended_card_response, as: :extendedCardResponse, class: Vantiv::Api::ExtendedCardResponse do
      property :code
      property :message
    end
  end

end
