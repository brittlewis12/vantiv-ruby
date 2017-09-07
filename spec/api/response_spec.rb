require 'spec_helper'

describe Vantiv::Api::Response do
  let(:httpok) { true }
  let(:transaction_response_name) { "authorizationResponse" }
  let(:response) do
    response = Vantiv::Api::Response.new
    response.httpok = httpok
    response.http_response_code = "1234"
    response.body = body
    response
  end

  def body_with_params(params)
    body_hash = {
      "litleOnlineResponse" => {
        "@message" => "this is a message",
        "@response" => "0"
      }.merge(params)
    }

    response_body = Vantiv::Api::ResponseBody.new
    ResponseBodyRepresenter.new(response_body).from_json(body_hash.to_json)
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

    context "when response is not 0" do
      let(:body) { body_with_params({ "@response" => "3" }) }

      it "is true" do
        expect(response.api_level_failure?).to eq(true)
      end
    end

    context "with an ok http response, no error message, and a '0' response" do
      let(:body) { body_with_params({ "@message" => "message", "@response" => "0" }) }

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
      let(:httpok) { false }
      let(:body) { Vantiv::Api::ResponseBody.new }

      it "returns the API level error message" do
        expect(response.error_message).to eq("API level error")
      end
    end

    context "when failure is due to xml validation" do
      let(:httpok) { true }
      let(:litle_error_message) do
        "Transaction amount [200000.00] exceeded limit of [100000.00]."
      end
      let(:bad_xml_response) do
        %Q(<litleOnlineResponse version="10.5" xmlns="http://www.litle.com/schema" response="1" message="#{litle_error_message}"/>)
      end
      let(:body) do
        response = Vantiv::Api::ResponseBody.new
        ResponseBodyRepresenterXml.new(response).from_xml(bad_xml_response)
      end

      it "returns the litle transaction's message" do
        expect(response.error_message).to eq(litle_error_message)
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

      it "returns the litle transaction's message" do
        set_transaction_response_name
        expect(response.error_message).to eq(non_api_error_message)
      end
    end
  end
end
