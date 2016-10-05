require 'spec_helper'
include TestHelpers

describe "mocked API requests to auth_capture" do
  let(:payment_account_id) { card.mocked_sandbox_payment_account_id }
  let(:live_sandbox_payment_account_id) do
    Vantiv::TestAccount.fetch_account(
      card_number: card.card_number,
      expiry_month: card.expiry_month,
      expiry_year: card.expiry_year,
      cvv: card.cvv
    ).payment_account_id
  end

  let(:customer_id) { "customer-#{rand(100)}" }
  let(:order_id) { "order-#{rand(100)}" }
  let(:amount) { 10100 }

  def run_mocked_response
    Vantiv::MockedSandbox.enable_self_mocked_requests!
    response = Vantiv.auth_capture(
      amount: amount,
      payment_account_id: payment_account_id,
      customer_id: customer_id,
      order_id: order_id,
      expiry_month: card.expiry_month,
      expiry_year: card.expiry_year,
      use_xml: use_xml
    )
    Vantiv::MockedSandbox.disable_self_mocked_requests!
    response
  end

  let(:mocked_response) { run_mocked_response }
  let(:live_response) do
    Vantiv.auth_capture(
      amount: amount,
      payment_account_id: live_sandbox_payment_account_id,
      customer_id: customer_id,
      order_id: order_id,
      expiry_month: card.expiry_month,
      expiry_year: card.expiry_year,
      use_xml: use_xml
    )
  end

  after { Vantiv::MockedSandbox.disable_self_mocked_requests! }

  context "when use_xml is false" do
    let(:use_xml) { false }

    Vantiv::TestCard.all.each do |test_card|
      next unless test_card.tokenizable?

      let(:card) { test_card }

      context "with a #{test_card.name}" do
        it "the mocked response's public methods return the same as the live one" do
          (
          Vantiv::Api::LiveTransactionResponse.instance_methods(false) +
            Vantiv::Api::Response.instance_methods(false) -
            [:payment_account_id, :body, :raw_body, :load, :request_id, :transaction_id, :account_updater]
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

        it "returns a raw body string" do
          expect(mocked_response.raw_body).to be_an_instance_of String
        end

        it "returns a dynamic transaction id" do
          response_1 = run_mocked_response
          response_2 = run_mocked_response
          expect(response_1.transaction_id).not_to eq response_2.transaction_id
        end

        context "when the response has account updater information" do
          let(:live_account_updater_response) { live_response.account_updater }
          let(:mocked_account_updater_response) { mocked_response.account_updater }

          it "has an equivalent payment_account_id" do
            expect(mocked_account_updater_response.payment_account_id).to eq live_account_updater_response.payment_account_id
          end

          it "has an equivalent card_type" do
            expect(mocked_account_updater_response.card_type).to eq live_account_updater_response.card_type
          end

          it "has an equivalent expiry_month" do
            expect(mocked_account_updater_response.expiry_month).to eq live_account_updater_response.expiry_month
          end

          it "has an equivalent expiry_year" do
            expect(mocked_account_updater_response.expiry_year).to eq live_account_updater_response.expiry_year
          end

          it "has an equivalent extended_card_response_code" do
            expect(mocked_account_updater_response.extended_card_response_code).to eq live_account_updater_response.extended_card_response_code
          end
        end
      end
    end
  end

  context "when use_xml is true" do
    let(:use_xml) { true }

    Vantiv::TestCard.all.each do |test_card|
      next unless test_card.tokenizable?

      let(:card) { test_card }

      context "with a #{test_card.name}" do
        it "the mocked response's public methods return the same as the live one" do
          (
          Vantiv::Api::LiveTransactionResponse.instance_methods(false) +
            Vantiv::Api::Response.instance_methods(false) -
            [:payment_account_id, :body, :raw_body, :load, :request_id, :transaction_id, :account_updater]
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

        it "returns a raw body string" do
          expect(mocked_response.raw_body).to be_an_instance_of String
        end

        it "returns a dynamic transaction id" do
          response_1 = run_mocked_response
          response_2 = run_mocked_response
          expect(response_1.transaction_id).not_to eq response_2.transaction_id
        end

        context "when the response has account updater information" do
          let(:live_account_updater_response) { live_response.account_updater }
          let(:mocked_account_updater_response) { mocked_response.account_updater }

          it "has an equivalent payment_account_id" do
            expect(mocked_account_updater_response.payment_account_id).to eq live_account_updater_response.payment_account_id
          end

          it "has an equivalent card_type" do
            expect(mocked_account_updater_response.card_type).to eq live_account_updater_response.card_type
          end

          it "has an equivalent expiry_month" do
            expect(mocked_account_updater_response.expiry_month).to eq live_account_updater_response.expiry_month
          end

          it "has an equivalent expiry_year" do
            expect(mocked_account_updater_response.expiry_year).to eq live_account_updater_response.expiry_year
          end

          it "has an equivalent extended_card_response_code" do
            expect(mocked_account_updater_response.extended_card_response_code).to eq live_account_updater_response.extended_card_response_code
          end
        end
      end
    end
  end
end
