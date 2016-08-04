require 'spec_helper'

describe Vantiv::Api::Card do
  describe "#format_expiry" do
    it "returns a two digit value if a one digit month is passed" do
      expect(Vantiv::Api::Card.new.format_expiry("8")).to eq "08"
    end

    it "returns a two digit value if two digit value is passed" do
      expect(Vantiv::Api::Card.new.format_expiry("08")).to eq "08"
    end

    it "returns a string if a number is passed" do
      expect(Vantiv::Api::Card.new.format_expiry(8)).to eq "08"
    end

    it "returns the last two digits if a four digit year is passed" do
      expect(Vantiv::Api::Card.new.format_expiry("2019")).to eq "19"
      expect(Vantiv::Api::Card.new.format_expiry(2019)).to eq "19"
    end
  end

end