require 'spec_helper'

describe Vantiv::Api::Request do
  let(:general_response_class) do
    Class.new(Vantiv::Api::Response) do
      def initialize
        @transaction_response_name = "tokenization_response"
      end
    end
  end

  subject(:run_api_request) do
    Vantiv::Api::Request.new(
      endpoint: Vantiv::Api::Endpoints::TOKENIZATION,
      body: Vantiv::Api::RequestBody.for_tokenization(
        paypage_registration_id: "1234"
      ),
      response_object: general_response_class.new
    ).run
  end

  context "running an API request when authentication fails" do
    before do
      @cached_license_id = Vantiv.license_id
      Vantiv.configure do |config|
        config.license_id = "asdfasdf"
      end
    end

    after do
      Vantiv.configure do |config|
        config.license_id = @cached_license_id
      end
    end

    it "does not raise errors on standard method retrieval" do
      response = run_api_request
      expect(response.message).to eq nil
      expect(response.response_code).to eq nil
      expect(response.transaction_id).to eq nil
    end

    it "returns the API level error message" do
      response = run_api_request
      expect(response.error_message).to eq "API level error"
    end

    it "returns an api level failure" do
      expect(run_api_request.api_level_failure?).to eq true
    end
  end

  context "when Vantiv (conveniently) doesn't send back json" do

    it "retries the original request" do
      vantiv_responses = [
        double(
          code_type: Net::HTTPOK,
          code: "200",
          body: ""
        ),
        double(
          code_type: Net::HTTPOK,
          code: "200",
          body: {"litleOnlineResponse":{"@version": "blabla"}}.to_json
        )
      ]
      allow_any_instance_of(Net::HTTP).to receive(:request) { vantiv_responses.shift }
      expect{
        @response = run_api_request
      }.not_to raise_error
      expect(@response.body.version).to eq "blabla"
    end
  end

  it "sets the raw response on the response object" do
    allow_any_instance_of(Net::HTTP)
      .to receive(:request)
      .and_return(double('http response', body: "some body").as_null_object)

    allow_any_instance_of(ResponseBodyRepresenter)
      .to receive(:from_json)

    expect(run_api_request.raw_body).to eq("some body")
  end
end
