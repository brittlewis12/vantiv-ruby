require 'spec_helper'

describe Vantiv::ResponseCodeMap do
  describe ".get_error_description" do
    it "returns a description from an error code" do
      expect(described_class.get_error_description(code: "000"))
        .to eq('No action required.')
    end

    describe "when no matching code is found" do
      it "raises a NoDescriptionFound error" do
        expect {
          described_class.get_error_description(code: "garbage")
        }.to raise_error(described_class::NoResponseDetailsFoundError)
      end
    end
  end
end
