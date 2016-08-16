require 'spec_helper'

describe Vantiv::Api::Response do
  let(:httpok) { true }
  let(:transaction_response_name) { "authorizationResponse" }
  let(:response) do
    response = Vantiv::Api::Response.new
    response.load(
      httpok: httpok,
      http_response_code: "1234",
      body: body
    )
    response
  end

  def body_with_params(params)
    body_hash = {
      "litleOnlineResponse" => {
        "@message" => "this is a message"
      }.merge(params)
    }

    response = Vantiv::Api::ResponseBody.new
    ResponseBodyRepresenter.new(response).from_json(body_hash.to_json)
  end

  def set_transaction_response_name
    response.instance_variable_set(
      :@transaction_response_name,
      "authorization_response"
    )
  end

  describe "api_level_failure?" do

    context "when the http response code is not ok" do
      let(:httpok) { false }
      let(:body) { Vantiv::Api::ResponseBody.new }

      it "is true" do
        expect(response.api_level_failure?).to eq(true)
      end
    end

    context "when there is an error message present" do
      let(:body) { body_with_params({"@message" => "error"}) }

      it "is true" do
        expect(response.api_level_failure?).to eq(true)
      end
    end

    context "with an ok http response and no error message" do
      let(:body) { body_with_params({ "@message" => "message" }) }

      it "is false" do
        expect(response.api_level_failure?).to eq(false)
      end
    end
  end

  describe "#message" do
    let(:message) { "some message" }
    let(:body) do
      body_with_params({
        transaction_response_name => {
          "message" => message
        }
      })
    end

    it "returns the litle transaction response's message" do
      set_transaction_response_name
      expect(response.message).to eq(message)
    end
  end

  describe "#error_message" do
    context "when configuration leads to API level failure" do
      let(:api_error_message) { "error message" }
      let(:httpok) { false }
      let(:body) { Vantiv::Api::ResponseBody.new }

      it "returns the API level error message" do
        expect(response.error_message).to eq("API level error")
      end
    end

    context "with a non api-level failure" do
      let(:httpok) { true }
      let(:non_api_error_message) { "other error message" }
      let(:body) do
        body_with_params({
          transaction_response_name => {
            "message" => non_api_error_message
          }
        })
      end

      it "returns the litle transaction's  message" do
        set_transaction_response_name
        expect(response.error_message).to eq(non_api_error_message)
      end
    end
  end
end
