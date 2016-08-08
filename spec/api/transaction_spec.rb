require 'spec_helper'

describe Vantiv::Api::Transaction do
  let(:subject) { Vantiv::Api::Transaction.new }

  describe "#amount" do
    context "formatting" do
      it "returns nil with amount_in_cents is nil" do
        subject.amount_in_cents = nil
        expect(subject.amount).to eq nil
      end

      it "4224 cents is formatted with 2 decimals" do
        subject.amount_in_cents = 4224
        expect(subject.amount).to eq "42.24"
      end

      it "424 cents cents is formatted with 2 decimals" do
        subject.amount_in_cents = 424
        expect(subject.amount).to eq "4.24"
      end

      it "4 cents cents is formatted with 2 decimals" do
        subject.amount_in_cents = 4
        expect(subject.amount).to eq "0.04"
      end

      it "881424 cents cents is formatted with 2 decimals" do
        subject.amount_in_cents = 881424
        expect(subject.amount).to eq "8814.24"
      end
    end
  end

  describe "#amount=" do
    it "sets amount" do
      expect{ subject.amount = "25.50" }.to change{subject.amount}.to "25.50"
    end

    it "sets amount_in_cents" do
      subject.amount_in_cents = 50
      expect{ subject.amount = "10.10" }
          .to change{ subject.amount_in_cents }.from(50).to(1010)
    end
  end
end
