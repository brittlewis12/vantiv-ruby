require 'spec_helper'

describe "auth_capture (Sale)" do
  subject(:response) do
    Vantiv.auth_capture(
      amount: 10000,
      payment_account_id: payment_account_id,
      customer_id: customer_external_id,
      order_id: "SomeOrder123",
      expiry_month: test_account.expiry_month,
      expiry_year: test_account.expiry_year
    )
  end

  let(:use_xml) { true }
  let(:customer_external_id) { "1234" }
  let(:payment_account_id) { test_account.payment_account_id }

  context "on a valid account" do
    let(:test_account) { Vantiv::TestAccount.valid_account }

    it "returns success response" do
      expect(response.success?).to eq true
    end

    it "returns a transaction ID" do
      expect(response.transaction_id).not_to eq nil
      expect(response.transaction_id).not_to eq ""
    end

    it "returns a '000' response code" do
      expect(response.response_code).to eq('000')
    end
  end

  context "on an account with insufficient funds" do
    let(:test_account) { Vantiv::TestAccount.insufficient_funds }

    it "returns a failure response" do
      expect(response.success?).to eq false
      expect(response.failure?).to eq true
    end

    it "returns a transaction ID" do
      expect(response.transaction_id).not_to eq nil
      expect(response.transaction_id).not_to eq ""
    end

    it "gives a human readable reason" do
      expect(response.message).to match(/insufficient funds/i)
    end

    it "notifies that it is insufficient funds" do
      expect(response.insufficient_funds?).to eq true
    end

    it "returns a '110' response code" do
      expect(response.response_code).to eq('110')
    end
  end

  context "on an account with an invalid account number" do
    let(:test_account) { Vantiv::TestAccount.invalid_account_number }

    it "returns a failure response" do
      expect(response.success?).to eq false
      expect(response.failure?).to eq true
    end

    it "returns a transaction ID" do
      expect(response.transaction_id).not_to eq nil
      expect(response.transaction_id).not_to eq ""
    end

    it "gives a human readable reason" do
      expect(response.message).to match(/invalid account number/i)
    end

    it "responds to invalid_account_number?" do
      expect(response.invalid_account_number?).to eq true
    end

    it "returns a '301' response code" do
      expect(response.response_code).to eq('301')
    end
  end

  context "on an account with misc errors, like pick up card" do
    let(:test_account) { Vantiv::TestAccount.pick_up_card }

    it "returns a failure response" do
      expect(response.success?).to eq false
      expect(response.failure?).to eq true
    end

    it "returns a transaction ID" do
      expect(response.transaction_id).not_to eq nil
      expect(response.transaction_id).not_to eq ""
    end

    it "gives a human readable reason" do
      expect(response.message).not_to eq nil
      expect(response.message).not_to eq ""
    end

    it "returns a '303' response code" do
      expect(response.response_code).to eq('303')
    end
  end

  context "when API level failure occurs" do
    let(:test_account) { Vantiv::TestAccount.valid_account }

    before do
      @vantiv_user = Vantiv.user
      Vantiv.user = "fake_user"
    end

    after do
      Vantiv.user = @vantiv_user
    end

    it "responds that the authorization failed" do
      expect(response.failure?).to eq true
      expect(response.api_level_failure?).to eq true
    end
  end

  context "when no order source is passed in" do
    let(:test_account) { Vantiv::TestAccount.valid_account }

    before do
      request_double = double('request')
      allow(Vantiv::Api::Request).to receive(:new) { request_double }
      allow(request_double).to receive :run
    end

    it "uses the default order_source" do
      expect(Vantiv::Api::RequestBody).to receive(:for_auth_or_sale).with(
        hash_including(order_source: Vantiv.default_order_source)
      )
      response
    end
  end

  context "when an order source is passed in" do
    let(:test_account) { Vantiv::TestAccount.valid_account }

    subject(:response) do
      Vantiv.auth_capture(
        amount: 10000,
        payment_account_id: payment_account_id,
        customer_id: customer_external_id,
        order_id: "SomeOrder123",
        expiry_month: test_account.expiry_month,
        expiry_year: test_account.expiry_year,
        order_source: "custom-order-source"
      )
    end

    before do
      request_double = double('request')
      allow(Vantiv::Api::Request).to receive(:new) { request_double }
      allow(request_double).to receive :run
    end

    it "uses the passed in order_source" do
      expect(Vantiv::Api::RequestBody).to receive(:for_auth_or_sale).with(
        hash_including(order_source: "custom-order-source")
      )
      response
    end
  end

  context "when an online payment cryptogram is passed in" do
    let(:test_account) { Vantiv::TestAccount.valid_account }

    subject(:response) do
      Vantiv.auth_capture(
        amount: 10000,
        payment_account_id: payment_account_id,
        customer_id: customer_external_id,
        order_id: "SomeOrder123",
        expiry_month: test_account.expiry_month,
        expiry_year: test_account.expiry_year,
        online_payment_cryptogram: "my-online-payment-cryptogram"
      )
    end

    before do
      request_double = double('request')
      allow(Vantiv::Api::Request).to receive(:new) { request_double }
      allow(request_double).to receive :run
    end

    it "uses the passed in online payment cryptogram" do
      expect(Vantiv::Api::RequestBody).to receive(:for_auth_or_sale).with(
        hash_including(online_payment_cryptogram: "my-online-payment-cryptogram")
      )
      response
    end
  end
end
