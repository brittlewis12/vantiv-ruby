require 'json'
require 'net/http'
require 'representable/xml'
require 'monkey_patches/representable/xml'
require 'vantiv/api'
require 'vantiv/test_card'
require 'vantiv/test_temporary_token'
require 'vantiv/environment'
require 'vantiv/mocked_sandbox'
require 'vantiv/paypage'

module Vantiv
  def self.tokenize(temporary_token:, use_xml: false)
    if temporary_token == "" or temporary_token == nil
      raise ArgumentError.new("Blank temporary token (PaypageRegistrationID): \n
                               Check that paypage error handling is implemented correctly.")
    end

    body = Api::RequestBody.for_tokenization(
      paypage_registration_id: temporary_token
    )
    Api::Request.new(
      endpoint: Api::Endpoints::TOKENIZATION,
      body: body,
      response_object: Api::TokenizationResponse.new,
      use_xml: use_xml
    ).run
  end

  def self.tokenize_by_direct_post(card_number:, expiry_month:, expiry_year:, cvv:, use_xml: false)
    body = Api::RequestBody.for_direct_post_tokenization(
      card_number: card_number,
      expiry_month: expiry_month,
      expiry_year: expiry_year,
      cvv: cvv
    )
    Api::Request.new(
      endpoint: Api::Endpoints::TOKENIZATION,
      body: body,
      response_object: Api::TokenizationResponse.new,
      use_xml: use_xml
    ).run
  end

  def self.auth(amount:, payment_account_id:, customer_id:, order_id:, expiry_month:, expiry_year:, use_xml: false)
    body = Api::RequestBody.for_auth_or_sale(
      amount: amount,
      order_id: order_id,
      customer_id: customer_id,
      payment_account_id: payment_account_id,
      expiry_month: expiry_month,
      expiry_year: expiry_year
    )
    Api::Request.new(
      endpoint: Api::Endpoints::AUTHORIZATION,
      body: body,
      response_object: Api::LiveTransactionResponse.new(:auth),
      use_xml: use_xml
    ).run
  end

  def self.auth_reversal(transaction_id:, amount: nil, use_xml: false)
    body = Api::RequestBody.for_auth_reversal(
      transaction_id: transaction_id,
      amount: amount
    )

    Api::Request.new(
      endpoint: Api::Endpoints::AUTH_REVERSAL,
      body: body,
      response_object: Api::TiedTransactionResponse.new(:auth_reversal),
      use_xml: use_xml
    ).run
  end

  def self.capture(transaction_id:, amount: nil, use_xml: false)
    body = Api::RequestBody.for_capture(
      transaction_id: transaction_id,
      amount: amount
    )

    Api::Request.new(
      endpoint: Api::Endpoints::CAPTURE,
      body: body,
      response_object: Api::TiedTransactionResponse.new(:capture),
      use_xml: use_xml
    ).run
  end

  def self.auth_capture(amount:, payment_account_id:, customer_id:, order_id:,
      expiry_month:, expiry_year:, use_xml: false, order_source: Vantiv.default_order_source)
    body = Api::RequestBody.for_auth_or_sale(
      amount: amount,
      order_id: order_id,
      customer_id: customer_id,
      payment_account_id: payment_account_id,
      expiry_month: expiry_month,
      expiry_year: expiry_year,
      order_source: order_source
    )
    Api::Request.new(
      endpoint: Api::Endpoints::SALE,
      body: body,
      response_object: Api::LiveTransactionResponse.new(:sale),
      use_xml: use_xml
    ).run
  end

  # NOTE: ActiveMerchant's #refund... only for use on a capture or sale it seems
  #       -> 'returns' are refunds too, credits are tied to a sale/capture, returns can be willy nilly
  def self.credit(transaction_id:, amount: nil, use_xml: false)
    body = Api::RequestBody.for_credit(
      amount: amount,
      transaction_id: transaction_id
    )
    Api::Request.new(
      endpoint: Api::Endpoints::CREDIT,
      body: body,
      response_object: Api::TiedTransactionResponse.new(:credit),
      use_xml: use_xml
    ).run
  end

  def self.refund(amount:, payment_account_id:, customer_id:, order_id:,
      expiry_month:, expiry_year:, order_source: Vantiv.default_order_source)
    body = Api::RequestBody.for_return(
      amount: amount,
      customer_id: customer_id,
      order_id: order_id,
      payment_account_id: payment_account_id,
      expiry_month: expiry_month,
      expiry_year: expiry_year,
      order_source: order_source
    )
    Api::Request.new(
      endpoint: Api::Endpoints::RETURN,
      body: body,
      response_object: Api::TiedTransactionResponse.new(:return)
    ).run
  end

  # NOTE: can void credits
  def self.void(transaction_id:)
    Api::Request.new(
      endpoint: Api::Endpoints::VOID,
      body: Api::RequestBody.for_void(transaction_id: transaction_id),
      response_object: Api::TiedTransactionResponse.new(:void)
    ).run
  end

  def self.configure
    yield self
  end

  class << self
    [
      :environment, :license_id, :acceptor_id, :default_report_group,
      :default_order_source, :paypage_id, :user, :password
    ].each do |config_var|
      define_method :"#{config_var}" do
        value = instance_variable_get(:"@#{config_var}")
        raise "Missing Vantiv configuration: #{config_var}" unless value
        value
      end

      define_method :"#{config_var}=" do |value|
        instance_variable_set(:"@#{config_var}", value)
      end
    end
  end

  def self.root
    File.dirname __dir__
  end
end

