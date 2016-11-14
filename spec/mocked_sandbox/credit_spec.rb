require 'spec_helper'

describe "mocked API requests to credit" do
  let(:live_response) do
    payment_account_id = Vantiv::TestAccount.fetch_account(
      card_number: card.card_number,
      expiry_month: card.expiry_month,
      expiry_year: card.expiry_year,
      cvv: card.cvv
    ).payment_account_id

    transaction_id = Vantiv.auth_capture(
      amount: 10100,
      payment_account_id: payment_account_id,
      customer_id: "54321",
      order_id: "12345",
      expiry_month: card.expiry_month,
      expiry_year: card.expiry_year
    ).transaction_id

    Vantiv.credit(transaction_id: transaction_id, amount: 10100)
  end

  def run_mocked_response
    Vantiv::MockedSandbox.enable_self_mocked_requests!
    transaction_id = rand(10 ** 17)

    Vantiv.credit(
      transaction_id: transaction_id,
      amount: 10100
    ).tap do
      Vantiv::MockedSandbox.disable_self_mocked_requests!
    end
  end

  let(:mocked_response) { run_mocked_response }

  after { Vantiv::MockedSandbox.disable_self_mocked_requests! }

  Vantiv::TestCard.all.each do |test_card|
    let(:card) { test_card }

    context "with a #{test_card.name}" do
      it "returns the same attributes in the live and mocked responses" do
        expect(live_response.success?).to eq mocked_response.success?
        expect(live_response.failure?).to eq mocked_response.failure?
        expect(live_response.message).to eq mocked_response.message
        expect(live_response.error_message).to eq mocked_response.error_message
        expect(live_response.httpok).to eq mocked_response.httpok
        expect(live_response.http_response_code).to eq mocked_response.http_response_code
        expect(live_response.api_level_failure?).to eq mocked_response.api_level_failure?
        expect(mocked_response.raw_body).to be_an_instance_of String
      end

      it "returns a dynamic transaction id" do
        response_1 = run_mocked_response
        response_2 = run_mocked_response
        expect(response_1.transaction_id).not_to eq response_2.transaction_id
      end
    end
  end
end
