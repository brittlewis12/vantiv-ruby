require 'spec_helper'
require 'vantiv/certification/paypage_driver'
include TestHelpers

describe "mocked API requests to .tokenize" do
  def run_mocked_response
    Vantiv::MockedSandbox.enable_self_mocked_requests!
    response = Vantiv.tokenize(temporary_token: mocked_temporary_token)
    Vantiv::MockedSandbox.disable_self_mocked_requests!
    response
  end

  let(:mocked_response) { run_mocked_response }
  let(:live_response) do
    Vantiv.tokenize(temporary_token: live_temporary_token)
  end

  before :all do
    @test_paypage_driver = Vantiv::Certification::PaypageDriver.new
    @test_paypage_driver.start
  end

  after :all do
    @test_paypage_driver.stop
  end

  after { Vantiv::MockedSandbox.disable_self_mocked_requests! }

  context "with a valid temporary token" do
    let(:card) { Vantiv::TestCard.valid_account }
    let(:live_temporary_token) do
      @test_paypage_driver.get_paypage_registration_id(
        card.card_number,
        card.cvv
      )
    end
    let(:mocked_temporary_token) do
      Vantiv::TestTemporaryToken.valid_temporary_token
    end

    it "the mocked response's public methods return the same as the live one" do
      (
      Vantiv::Api::TokenizationResponse.instance_methods(false) +
        Vantiv::Api::Response.instance_methods(false) -
        [:payment_account_id, :body, :raw_body, :load, :request_id, :transaction_id]
      ).each do |method_name|
        next if method_name.to_s.end_with?("=")

        live_response_value = live_response.send(method_name)
        mocked_response_value = mocked_response.send(method_name)

        expect(mocked_response_value).to eq(live_response_value),
          error_message_for_mocked_api_failure(
           method_name: method_name,
           expected_value: live_response_value,
           got_value: mocked_response_value,
           live_response: live_response
          )
      end
    end

    it "returns the whitelisted payment account id" do
      expect(mocked_response.success?).to eq true
      expect(mocked_response.payment_account_id).to eq card.mocked_sandbox_payment_account_id
    end

    it "returns a dynamic transaction id" do
      response_1 = run_mocked_response
      response_2 = run_mocked_response
      expect(response_1.transaction_id).not_to eq response_2.transaction_id
    end
  end

  context "with an expired temporary token" do
    let(:live_temporary_token) do
      # test token that always returns an expired response
      "RGFQNCt6U1d1M21SeVByVTM4dHlHb1FsVkUrSmpnWXhNY0o5UkMzRlZFanZiUHVnYjN1enJXbG1WSDF4aXlNcA=="
    end
    let(:mocked_temporary_token) do
      Vantiv::TestTemporaryToken.expired_temporary_token
    end

    it "the mocked response's public methods return the same as the live one" do
      (
      Vantiv::Api::TokenizationResponse.instance_methods(false) +
        Vantiv::Api::Response.instance_methods(false) -
        [:payment_account_id, :body, :raw_body, :load, :request_id, :transaction_id]
      ).each do |method_name|
        next if method_name.to_s.end_with?("=")

        live_response_value = live_response.send(method_name)
        mocked_response_value = mocked_response.send(method_name)

        expect(mocked_response_value).to eq(live_response_value),
          error_message_for_mocked_api_failure(
           method_name: method_name,
           expected_value: live_response_value,
           got_value: mocked_response_value,
           live_response: live_response
          )
      end
    end

    it "returns the same error message" do
      expect(mocked_response.success?).to eq false
      expect(mocked_response.error_message).to eq live_response.error_message
    end

    it "returns a raw body string" do
      expect(mocked_response.raw_body).to be_an_instance_of String
    end

    it "returns a dynamic transaction id" do
      response_1 = run_mocked_response
      response_2 = run_mocked_response
      expect(response_1.transaction_id).not_to eq response_2.transaction_id
    end
  end

  context "with an invalid temporary token" do
    let(:live_temporary_token) do
      # test token that always returns an invalid response
      "pDZJcmd1VjNlYXNaSlRMTGpocVZQY1NWVXE4Z W5UTko4NU9KK3p1L1p1Vzg4YzVPQVlSUHNITG1 JN2I0NzlyTg=="
    end
    let(:mocked_temporary_token) do
      Vantiv::TestTemporaryToken.invalid_temporary_token
    end

    it "the mocked response's public methods return the same as the live one" do
      (
      Vantiv::Api::TokenizationResponse.instance_methods(false) +
        Vantiv::Api::Response.instance_methods(false) -
        [:payment_account_id, :body, :raw_body, :load, :request_id, :transaction_id]
      ).each do |method_name|
        next if method_name.to_s.end_with?("=")

        live_response_value = live_response.send(method_name)
        mocked_response_value = mocked_response.send(method_name)

        expect(mocked_response_value).to eq(live_response_value),
          error_message_for_mocked_api_failure(
           method_name: method_name,
           expected_value: live_response_value,
           got_value: mocked_response_value,
           live_response: live_response
          )
      end
    end

    it "returns the same error message" do
      expect(mocked_response.success?).to eq false
      expect(mocked_response.error_message).to eq live_response.error_message
    end

    it "returns a dynamic transaction id" do
      response_1 = run_mocked_response
      response_2 = run_mocked_response
      expect(response_1.transaction_id).not_to eq response_2.transaction_id
    end
  end
end
