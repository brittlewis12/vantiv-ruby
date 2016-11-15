require 'spec_helper'

describe Vantiv::Api::RequestBody do
  describe ".for_direct_post_tokenization" do
    let(:card_number) { 1234 }
    let(:expiry_month) { 10 }
    let(:expiry_year) { 2018 }
    let(:cvv) { 222 }

    subject(:request_body) do
      Vantiv::Api::RequestBody.for_direct_post_tokenization(
        card_number: card_number,
        expiry_month: expiry_month,
        expiry_year: expiry_year,
        cvv: cvv
      )
    end

    it "includes the acceptor id" do
      allow(Vantiv).to receive(:acceptor_id).and_return "acceptor-id"
      expect(request_body.acceptor_id).to eq "acceptor-id"
    end

    it "includes the default report group" do
      expect(request_body.report_group).to eq "1"
    end

    it "include the application id" do
      expect(request_body.application_id).to be
    end

    it "includes stringified versions of card params" do
      expect(request_body.card.account_number).to eq card_number.to_s
      expect(request_body.card.expiry_month).to eq "10"
      expect(request_body.card.expiry_year).to eq "18"
      expect(request_body.card.cvv).to eq cvv.to_s
    end
  end

  describe ".for_tokenization" do
    subject(:request_body) do
      Vantiv::Api::RequestBody.for_tokenization(
        paypage_registration_id: @paypage_registration_id
      )
    end

    before do
      @paypage_registration_id = "some-temp-token"
    end

    it "includes the acceptor id" do
      allow(Vantiv).to receive(:acceptor_id).and_return "acceptor-id"
      expect(request_body.acceptor_id).to eq "acceptor-id"
    end

    it "includes the default report group" do
      expect(request_body.report_group).to eq "1"
    end

    it "include the application id" do
      expect(request_body.application_id).to be
    end

    it "includes the paypage registration id" do
      expect(request_body.card.paypage_registration_id).to eq "some-temp-token"
    end
  end

  describe ".for_capture" do
    subject(:request_body) do
      Vantiv::Api::RequestBody.for_capture(
        amount: @amount,
        transaction_id: "transactionid123"
      )
    end

    context "when amount is nil" do
      before do
        @amount = nil
      end

      it "includes the acceptor id" do
        allow(Vantiv).to receive(:acceptor_id).and_return "acceptor-id"
        expect(request_body.acceptor_id).to eq "acceptor-id"
      end

      it "includes the default report group" do
        expect(request_body.report_group).to eq "1"
      end

      it "include the application id" do
        expect(request_body.application_id).to be
      end

      it "includes the transaction id" do
        expect(request_body.transaction.id).to eq "transactionid123"
      end

      it "does not include the transaction amount" do
        expect(request_body.transaction.amount).to be_nil
      end
    end

    context "when amount is not nil" do
      before do
        @amount = 58888
      end

      it "includes the acceptor id" do
        allow(Vantiv).to receive(:acceptor_id).and_return "acceptor-id"
        expect(request_body.acceptor_id).to eq "acceptor-id"
      end

      it "includes the default report group" do
        expect(request_body.report_group).to eq "1"
      end

      it "include the application id" do
        expect(request_body.application_id).to be
      end

      it "includes the transaction id" do
        expect(request_body.transaction.id).to eq "transactionid123"
      end

      it "includes the transaction amount" do
        expect(request_body.transaction.amount).to eq "588.88"
      end
    end
  end

  describe ".for_auth_or_sale" do
    context "when order source is passed in" do
      subject(:request_body) do
        Vantiv::Api::RequestBody.for_auth_or_sale(
          amount: 4224,
          customer_id: "extid123",
          payment_account_id: "paymentacct123",
          order_id: "SomeOrder123",
          expiry_month: "8",
          expiry_year: "2018",
          order_source: "my-custom-order-source"
        )
      end

      it "sets the order source on the transaction" do
        expect(request_body.transaction.order_source).to eq "my-custom-order-source"
      end
    end

    context "when online payment cryptogram is passed in" do
      subject(:request_body) do
        Vantiv::Api::RequestBody.for_auth_or_sale(
          amount: 4224,
          customer_id: "extid123",
          payment_account_id: "paymentacct123",
          order_id: "SomeOrder123",
          expiry_month: "8",
          expiry_year: "2018",
          online_payment_cryptogram: "my-online-payment-cryptogram"
        )
      end

      it "sets the cardholder authentication value" do
        expect(request_body.transaction.cardholder_authentication.authentication_value).to eq "my-online-payment-cryptogram"
      end
    end

    context "when online payment cryptogram is not passed in" do
      subject(:request_body) do
        Vantiv::Api::RequestBody.for_auth_or_sale(
          amount: 4224,
          customer_id: "extid123",
          payment_account_id: "paymentacct123",
          order_id: "SomeOrder123",
          expiry_month: "8",
          expiry_year: "2018"
        )
      end

      it "sets the cardholder authentication value" do
        expect(request_body.transaction.cardholder_authentication).to eq nil
      end
    end

    subject(:request_body) do
      Vantiv::Api::RequestBody.for_auth_or_sale(
        amount: 4224,
        customer_id: "extid123",
        payment_account_id: "paymentacct123",
        order_id: "SomeOrder123",
        expiry_month: "8",
        expiry_year: "2018"
      )
    end

    it "includes the acceptor id" do
      allow(Vantiv).to receive(:acceptor_id).and_return "acceptor-id"
      expect(request_body.acceptor_id).to eq "acceptor-id"
    end

    it "includes the default report group" do
      expect(request_body.report_group).to eq "1"
    end

    it "include the application id" do
      expect(request_body.application_id).to be
    end

    context "Transaction object" do
      it "is included" do
        expect(request_body.transaction).to be
      end

      it "includes the order id" do
        expect(request_body.transaction.order_id).to eq "SomeOrder123"
      end

      it "includes the transaction amount" do
        expect(request_body.transaction.amount).to eq "42.24"
      end

      it "includes the order source" do
        expect(request_body.transaction.order_source).to eq "ecommerce"
      end

      it "includes the customer id" do
        expect(request_body.transaction.customer_id).to eq "extid123"
      end

      it "includes the partial approved flag" do
        expect(request_body.transaction.partial_approved_flag).to eq false
      end
    end

    context "Card object" do
      it "is included" do
        expect(request_body.card).to be
      end

      it "includes expiry month" do
        expect(request_body.card.expiry_month).to eq "08"
      end

      it "includes expiry year" do
        expect(request_body.card.expiry_year).to eq "18"
      end
    end

    it "includes the payment account id" do
      expect(request_body.payment_account.id).to eq "paymentacct123"
    end

    it "casts order id to string" do
      body = Vantiv::Api::RequestBody.for_auth_or_sale(
        amount: 4224,
        customer_id: "extid123",
        payment_account_id: "paymentacct123",
        order_id: 123,
        expiry_month: "12",
        expiry_year: "2099"
      )
      expect(body.transaction.order_id).to eq "123"
    end

  end

  describe ".for_auth_reversal" do
    subject(:request_body) do
      Vantiv::Api::RequestBody.for_auth_reversal(
        amount: @amount,
        transaction_id: "transactionid123"
      )
    end

    context "when amount is nil" do
      before do
        @amount = nil
      end

      it "includes the acceptor id" do
        allow(Vantiv).to receive(:acceptor_id).and_return "acceptor-id"
        expect(request_body.acceptor_id).to eq "acceptor-id"
      end

      it "includes the default report group" do
        expect(request_body.report_group).to eq "1"
      end

      it "include the application id" do
        expect(request_body.application_id).to be
      end

      it "includes the transaction id" do
        expect(request_body.transaction.id).to eq "transactionid123"
      end

      it "does not include the transaction amount" do
        expect(request_body.transaction.amount).to be_nil
      end
    end

    context "when amount is not nil" do
      before do
        @amount = 58888
      end

      it "includes the acceptor id" do
        allow(Vantiv).to receive(:acceptor_id).and_return "acceptor-id"
        expect(request_body.acceptor_id).to eq "acceptor-id"
      end

      it "includes the default report group" do
        expect(request_body.report_group).to eq "1"
      end

      it "include the application id" do
        expect(request_body.application_id).to be
      end

      it "includes the transaction id" do
        expect(request_body.transaction.id).to eq "transactionid123"
      end

      it "includes the transaction amount" do
        expect(request_body.transaction.amount).to eq "588.88"
      end
    end
  end

  describe ".for_credit" do
    subject(:request_body) do
      Vantiv::Api::RequestBody.for_credit(
        amount: @amount,
        transaction_id: "transactionid123"
      )
    end

    context "when amount is nil" do
      before do
        @amount = nil
      end

      it "includes the acceptor id" do
        allow(Vantiv).to receive(:acceptor_id).and_return "acceptor-id"
        expect(request_body.acceptor_id).to eq "acceptor-id"
      end

      it "includes the default report group" do
        expect(request_body.report_group).to eq "1"
      end

      it "include the application id" do
        expect(request_body.application_id).to be
      end

      it "includes the transaction id" do
        expect(request_body.transaction.id).to eq "transactionid123"
      end

      it "does not include the transaction amount" do
        expect(request_body.transaction.amount).to be_nil
      end
    end

    context "when amount is not nil" do
      before do
        @amount = 58888
      end

      it "includes the acceptor id" do
        allow(Vantiv).to receive(:acceptor_id).and_return "acceptor-id"
        expect(request_body.acceptor_id).to eq "acceptor-id"
      end

      it "includes the default report group" do
        expect(request_body.report_group).to eq "1"
      end

      it "include the application id" do
        expect(request_body.application_id).to be
      end

      it "includes the transaction id" do
        expect(request_body.transaction.id).to eq "transactionid123"
      end

      it "includes the transaction amount" do
        expect(request_body.transaction.amount).to eq "588.88"
      end
    end
  end

  describe ".for_return" do
    subject(:request_body) do
      Vantiv::Api::RequestBody.for_return(
        amount: 4224,
        customer_id: "extid123",
        payment_account_id: "paymentacct123",
        order_id: "SomeOrder123",
        expiry_month: "8",
        expiry_year: "2018"
      )
    end

    context "when order source is passed in" do
      subject(:request_body) do
        Vantiv::Api::RequestBody.for_return(
          amount: 4224,
          customer_id: "extid123",
          payment_account_id: "paymentacct123",
          order_id: "SomeOrder123",
          expiry_month: "8",
          expiry_year: "2018",
          order_source: "my-custom-order-source"
        )
      end

      it "sets the order source on the response body" do
        expect(request_body.transaction.order_source).to eq "my-custom-order-source"
      end
    end

    it "includes the acceptor id" do
      allow(Vantiv).to receive(:acceptor_id).and_return "acceptor-id"
      expect(request_body.acceptor_id).to eq "acceptor-id"
    end

    it "includes the default report group" do
      expect(request_body.report_group).to eq "1"
    end

    it "include the application id" do
      expect(request_body.application_id).to be
    end

    context "Transaction object" do
      it "is included" do
        expect(request_body.transaction).to be
      end

      it "includes the order id" do
        expect(request_body.transaction.order_id).to eq "SomeOrder123"
      end

      it "includes the amount" do
        expect(request_body.transaction.amount).to eq "42.24"
      end

      it "includes the order source" do
        expect(request_body.transaction.order_source).to eq "ecommerce"
      end

      it "includes the customer id" do
        expect(request_body.transaction.customer_id).to eq "extid123"
      end

      it "does not include the partial approved flag" do
        expect(request_body.transaction.partial_approved_flag).to be_nil
      end
    end

    context "Card object" do
      it "is included" do
        expect(request_body.card).to be
      end

      it "includes expiry month" do
        expect(request_body.card.expiry_month).to eq "08"
      end

      it "includes expiry year" do
        expect(request_body.card.expiry_year).to eq "18"
      end
    end

    it "includes the PaymentAccountID" do
      expect(request_body.payment_account.id).to eq "paymentacct123"
    end
  end

  describe ".for_void" do
    subject(:request_body) do
      Vantiv::Api::RequestBody.for_void(
        transaction_id: "transactionid123"
      )
    end

    it "includes the acceptor id" do
      allow(Vantiv).to receive(:acceptor_id).and_return "acceptor-id"
      expect(request_body.acceptor_id).to eq "acceptor-id"
    end

    it "includes the default report group" do
      expect(request_body.report_group).to eq "1"
    end

    it "include the application id" do
      expect(request_body.application_id).to be
    end

    it "includes the transaction id" do
      expect(request_body.transaction.id).to eq "transactionid123"
    end
  end

end
