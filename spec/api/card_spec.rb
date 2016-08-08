require 'spec_helper'

describe Vantiv::Api::Card do
  let(:subject) { Vantiv::Api::Card.new }

  describe "#expiry_month" do
    it "returns a two digit value if a one digit month is passed" do
      subject.expiry_month = "8"
      expect(subject.expiry_month).to eq "08"
    end

    it "returns a two digit value if two digit value is passed" do
      subject.expiry_month = "08"
      expect(subject.expiry_month).to eq "08"
    end

    it "returns a string if a number is passed" do
      subject.expiry_month = 8
      expect(subject.expiry_month).to eq "08"
    end
  end

  describe "#expiry_year" do
    it "returns a two digit value if two digit value is passed" do
      subject.expiry_month = "08"
      expect(subject.expiry_month).to eq "08"
    end

    it "returns a string if a number is passed" do
      subject.expiry_month = 6
      expect(subject.expiry_month).to eq "06"
    end

    it "returns the last two digits if a four digit year is passed" do
      subject.expiry_year = "2019"
      expect(subject.expiry_year).to eq "19"
    end
  end

  describe "#card_number" do
    it "strips whitespace" do
      subject.card_number = "1234 1234  0923"
      expect(subject.card_number).to eq("123412340923")
    end

    it "strips non-numeric characters" do
      subject.card_number = "1234-1234_xx"
      expect(subject.card_number).to eq("12341234")
    end

    it "returns a string if a number is passed" do
      subject.card_number = 12341234
      expect(subject.card_number).to eq("12341234")
    end
  end

  describe "#account_number" do
    it "strips whitespace" do
      subject.account_number = "1234 1234  0923"
      expect(subject.account_number).to eq("123412340923")
    end

    it "strips non-numeric characters" do
      subject.account_number = "1234-1234_xx"
      expect(subject.account_number).to eq("12341234")
    end

    it "returns a string if a number is passed" do
      subject.account_number = 12341234
      expect(subject.account_number).to eq("12341234")
    end
  end

  describe "#cvv" do
    it "returns a string if a number is passed" do
      subject.cvv = 132
      expect(subject.cvv).to eq("132")
    end
  end
end