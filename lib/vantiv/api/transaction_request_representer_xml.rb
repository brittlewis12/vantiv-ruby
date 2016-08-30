require 'representable/xml'

class TransactionRequestRepresenterXml < Representable::Decorator
  include Representable::XML

  self.representation_wrap = ->(_) { type }

  property :application_id, as: :id, attribute: true
  property :id, as: :litleTxnId
  property :report_group, as: :reportGroup, attribute: true
  property :customer_id, as: :customerId, attribute: true
  property :order_id, as: :orderId
  property :amount_in_cents, as: :amount
  property :order_source, as: :orderSource

  property :card, class: Vantiv::Api::Card, if: ->(_) { type != :registerTokenRequest && !card&.paypage_registration_id } do
    self.representation_wrap = ->(_) { !!payment_account_id ? :token : :card }

    property :type
    property :card_number, as: :number
    property :account_number, as: :number
    property :payment_account_id, as: :litleToken
    property :expDate,
             getter: ->(represented:, **) { represented.expiry_month.to_s + represented.expiry_year.to_s },
             if: ->(_) { expiry_month && expiry_year }
    property :cvv, as: :cardValidationNum
  end

  property :accountNumber,
           if: ->(_) { type == :registerTokenRequest },
           getter: ->(represented:, **) { represented.card&.account_number }

  property :paypageRegistrationId,
           getter: ->(represented:, **) { represented.card&.paypage_registration_id }

  property :partial_approved_flag, as: :allowPartialAuth
end
