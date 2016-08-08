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

    it "returns the expected body" do
      allow(SecureRandom).to receive(:hex).and_return "the-application-id"
      expected = {"Credentials"=>{"AcceptorID"=>"1166386"}, "Reports"=>{"ReportGroup"=>"1"}, "Application"=>{"ApplicationID"=>"the-application-id"}, "Card"=>{"AccountNumber"=>"1234", "ExpirationMonth"=>"10", "ExpirationYear"=>"18", "CVV"=>"222"}}
      expect(request_body).to eq(expected)
    end

    it "includes the AcceptorID" do
      expect(request_body["Credentials"]["AcceptorID"]).to eq("1166386")
    end

    it "includes the default ReportGroup" do
      expect(request_body["Reports"]["ReportGroup"]).to eq("1")
    end

    it "include the ApplicationID" do
      expect(request_body["Application"]["ApplicationID"]).to be
    end

    it "includes stringified versions of card params" do
      expect(request_body["Card"]["AccountNumber"]).to eq(card_number.to_s)
      expect(request_body["Card"]["ExpirationMonth"]).to eq("10")
      expect(request_body["Card"]["ExpirationYear"]).to eq("18")
      expect(request_body["Card"]["CVV"]).to eq(cvv.to_s)
    end

    context "with spaces in the credit card number" do
      let(:card_number) { "1234 1234" }

      it "strips whitespace" do
        expect(request_body["Card"]["AccountNumber"]).to eq("12341234")
      end
    end

    context "with non-numeric characters" do
      let(:card_number) { "1234-1234_xx" }

      it "strips the characters" do
        expect(request_body["Card"]["AccountNumber"]).to eq("12341234")
      end
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

    it "returns the expected body" do
      allow(SecureRandom).to receive(:hex).and_return "the-application-id"
      expected = {"Credentials"=>{"AcceptorID"=>"1166386"}, "Reports"=>{"ReportGroup"=>"1"}, "Application"=>{"ApplicationID"=>"the-application-id"}, "Card"=>{"PaypageRegistrationID"=>"some-temp-token"}}
      expect(request_body).to eq(expected)
    end

    it "includes the AcceptorID" do
      expect(request_body["Credentials"]["AcceptorID"]).to eq("1166386")
    end

    it "includes the default ReportGroup" do
      expect(request_body["Reports"]["ReportGroup"]).to eq("1")
    end

    it "include the ApplicationID" do
      expect(request_body["Application"]["ApplicationID"]).to be
    end

    it "includes the paypage registration ID correctly" do
      expect(request_body["Card"]["PaypageRegistrationID"]).to eq "some-temp-token"
    end
  end

  describe ".for_capture" do
    subject(:request_body) do
      Vantiv::Api::RequestBody.for_capture(
        amount: @amount,
        transaction_id: "transactionid123"
      )
    end

    it "returns the expected body" do
      allow(SecureRandom).to receive(:hex).and_return "the-application-id"
      expected = {"Credentials"=>{"AcceptorID"=>"1166386"}, "Reports"=>{"ReportGroup"=>"1"}, "Application"=>{"ApplicationID"=>"the-application-id"}, "Transaction"=>{"TransactionID"=>"transactionid123"}}
      expect(request_body).to eq(expected)
    end

    context "when amount is nil" do
      before do
        @amount = nil
      end

      it "includes the AcceptorID" do
        expect(request_body["Credentials"]["AcceptorID"]).to eq("1166386")
      end

      it "includes the default ReportGroup" do
        expect(request_body["Reports"]["ReportGroup"]).to eq("1")
      end

      it "include the ApplicationID" do
        expect(request_body["Application"]["ApplicationID"]).to be
      end

      it "includes the transaction id" do
        expect(request_body["Transaction"]["TransactionID"]).to eq("transactionid123")
      end

      it "does not include the TransactionAmount" do
        expect(request_body["Transaction"]["TransactionAmount"]).to be_nil
      end
    end

    context "when amount is not nil" do
      before do
        @amount = 58888
      end

      it "includes the AcceptorID" do
        expect(request_body["Credentials"]["AcceptorID"]).to eq("1166386")
      end

      it "includes the default ReportGroup" do
        expect(request_body["Reports"]["ReportGroup"]).to eq("1")
      end

      it "include the ApplicationID" do
        expect(request_body["Application"]["ApplicationID"]).to be
      end

      it "includes the transaction id" do
        expect(request_body["Transaction"]["TransactionID"]).to eq("transactionid123")
      end

      it "includes the TransactionAmount" do
        expect(request_body["Transaction"]["TransactionAmount"]).to eq("588.88")
      end
    end
  end

  describe ".for_auth_or_sale" do
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

    it "returns the expected body" do
      allow(SecureRandom).to receive(:hex).and_return "the-application-id"
      expected = {"Credentials"=>{"AcceptorID"=>"1166386"}, "Reports"=>{"ReportGroup"=>"1"}, "Application"=>{"ApplicationID"=>"the-application-id"}, "Transaction"=>{"ReferenceNumber"=>"SomeOrder123", "TransactionAmount"=>"42.24", "OrderSource"=>"ecommerce", "CustomerID"=>"extid123", "PartialApprovedFlag"=>false}, "Card"=>{"ExpirationMonth"=>"08", "ExpirationYear"=>"18"}, "PaymentAccount"=>{"PaymentAccountID"=>"paymentacct123"}}
      expect(request_body).to eq(expected)
    end

    it "includes the AcceptorID" do
      expect(request_body["Credentials"]["AcceptorID"]).to eq("1166386")
    end

    it "includes the default ReportGroup" do
      expect(request_body["Reports"]["ReportGroup"]).to eq("1")
    end

    it "include the ApplicationID" do
      expect(request_body["Application"]["ApplicationID"]).to be
    end

    context "Transaction object" do
      it "is included" do
        expect(request_body["Transaction"]).not_to eq nil
      end

      it "includes the ReferenceNumber" do
        expect(request_body["Transaction"]["ReferenceNumber"]).to eq "SomeOrder123"
      end

      it "includes the TransactionAmount" do
        expect(request_body["Transaction"]["TransactionAmount"]).to eq "42.24"
      end

      it "includes the OrderSource" do
        expect(request_body["Transaction"]["OrderSource"]).to eq "ecommerce"
      end

      it "includes the CustomerID" do
        expect(request_body["Transaction"]["CustomerID"]).to eq "extid123"
      end

      it "includes the PartialApprovedFlag" do
        expect(request_body["Transaction"]["PartialApprovedFlag"]).to eq false
      end
    end

    context "Card object" do
      it "is included" do
        expect(request_body["Card"]).not_to eq nil
      end

      it "includes ExpirationMonth" do
        expect(request_body["Card"]["ExpirationMonth"]).to eq "08"
      end

      it "includes ExpirationYear" do
        expect(request_body["Card"]["ExpirationYear"]).to eq "18"
      end
    end

    it "includes the PaymentAccountID" do
      expect(request_body["PaymentAccount"]["PaymentAccountID"]).to eq "paymentacct123"
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
      expect(body["Transaction"]["ReferenceNumber"]).to eq "123"
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

      it "returns the expected body" do
        allow(SecureRandom).to receive(:hex).and_return "the-application-id"
        expected = {"Credentials"=>{"AcceptorID"=>"1166386"}, "Reports"=>{"ReportGroup"=>"1"}, "Application"=>{"ApplicationID"=>"the-application-id"}, "Transaction"=>{"TransactionID"=>"transactionid123"}}
        expect(request_body).to eq(expected)
      end

      it "includes the AcceptorID" do
        expect(request_body["Credentials"]["AcceptorID"]).to eq("1166386")
      end

      it "includes the default ReportGroup" do
        expect(request_body["Reports"]["ReportGroup"]).to eq("1")
      end

      it "include the ApplicationID" do
        expect(request_body["Application"]["ApplicationID"]).to be
      end

      it "includes the transaction id" do
        expect(request_body["Transaction"]["TransactionID"]).to eq("transactionid123")
      end

      it "does not include the TransactionAmount" do
        expect(request_body["Transaction"]["TransactionAmount"]).to be_nil
      end
    end

    context "when amount is not nil" do
      before do
        @amount = 58888
      end

      it "returns the expected body" do
        allow(SecureRandom).to receive(:hex).and_return "the-application-id"
        expected = {"Credentials"=>{"AcceptorID"=>"1166386"}, "Reports"=>{"ReportGroup"=>"1"}, "Application"=>{"ApplicationID"=>"the-application-id"}, "Transaction"=>{"TransactionID"=>"transactionid123", "TransactionAmount"=>"588.88"}}
        expect(request_body).to eq(expected)
      end

      it "includes the AcceptorID" do
        expect(request_body["Credentials"]["AcceptorID"]).to eq("1166386")
      end

      it "includes the default ReportGroup" do
        expect(request_body["Reports"]["ReportGroup"]).to eq("1")
      end

      it "include the ApplicationID" do
        expect(request_body["Application"]["ApplicationID"]).to be
      end

      it "includes the transaction id" do
        expect(request_body["Transaction"]["TransactionID"]).to eq("transactionid123")
      end

      it "includes the TransactionAmount" do
        expect(request_body["Transaction"]["TransactionAmount"]).to eq("588.88")
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

      it "returns the expected body" do
        allow(SecureRandom).to receive(:hex).and_return "the-application-id"
        expected = {"Credentials"=>{"AcceptorID"=>"1166386"}, "Reports"=>{"ReportGroup"=>"1"}, "Application"=>{"ApplicationID"=>"the-application-id"}, "Transaction"=>{"TransactionID"=>"transactionid123"}}
        expect(request_body).to eq(expected)
      end

      it "includes the AcceptorID" do
        expect(request_body["Credentials"]["AcceptorID"]).to eq("1166386")
      end

      it "includes the default ReportGroup" do
        expect(request_body["Reports"]["ReportGroup"]).to eq("1")
      end

      it "include the ApplicationID" do
        expect(request_body["Application"]["ApplicationID"]).to be
      end

      it "includes the transaction id" do
        expect(request_body["Transaction"]["TransactionID"]).to eq("transactionid123")
      end

      it "does not include the TransactionAmount" do
        expect(request_body["Transaction"]["TransactionAmount"]).to be_nil
      end
    end

    context "when amount is not nil" do
      before do
        @amount = 58888
      end

      it "returns the expected body" do
        allow(SecureRandom).to receive(:hex).and_return "the-application-id"
        expected = {"Credentials"=>{"AcceptorID"=>"1166386"}, "Reports"=>{"ReportGroup"=>"1"}, "Application"=>{"ApplicationID"=>"the-application-id"}, "Transaction"=>{"TransactionID"=>"transactionid123", "TransactionAmount"=>"588.88"}}
        expect(request_body).to eq(expected)
      end

      it "includes the AcceptorID" do
        expect(request_body["Credentials"]["AcceptorID"]).to eq("1166386")
      end

      it "includes the default ReportGroup" do
        expect(request_body["Reports"]["ReportGroup"]).to eq("1")
      end

      it "include the ApplicationID" do
        expect(request_body["Application"]["ApplicationID"]).to be
      end

      it "includes the transaction id" do
        expect(request_body["Transaction"]["TransactionID"]).to eq("transactionid123")
      end

      it "includes the TransactionAmount" do
        expect(request_body["Transaction"]["TransactionAmount"]).to eq("588.88")
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

    it "returns the expected body" do
      allow(SecureRandom).to receive(:hex).and_return "the-application-id"
      expected = {"Credentials"=>{"AcceptorID"=>"1166386"}, "Reports"=>{"ReportGroup"=>"1"}, "Application"=>{"ApplicationID"=>"the-application-id"}, "Transaction"=>{"ReferenceNumber"=>"SomeOrder123", "TransactionAmount"=>"42.24", "OrderSource"=>"ecommerce", "CustomerID"=>"extid123"}, "Card"=>{"ExpirationMonth"=>"08", "ExpirationYear"=>"18"}, "PaymentAccount"=>{"PaymentAccountID"=>"paymentacct123"}}
      expect(request_body).to eq(expected)
    end

    it "includes the AcceptorID" do
      expect(request_body["Credentials"]["AcceptorID"]).to eq("1166386")
    end

    it "includes the default ReportGroup" do
      expect(request_body["Reports"]["ReportGroup"]).to eq("1")
    end

    it "include the ApplicationID" do
      expect(request_body["Application"]["ApplicationID"]).to be
    end

    context "Transaction object" do
      it "is included" do
        expect(request_body["Transaction"]).not_to eq nil
      end

      it "includes the ReferenceNumber" do
        expect(request_body["Transaction"]["ReferenceNumber"]).to eq "SomeOrder123"
      end

      it "includes the TransactionAmount" do
        expect(request_body["Transaction"]["TransactionAmount"]).to eq "42.24"
      end

      it "includes the OrderSource" do
        expect(request_body["Transaction"]["OrderSource"]).to eq "ecommerce"
      end

      it "includes the CustomerID" do
        expect(request_body["Transaction"]["CustomerID"]).to eq "extid123"
      end

      it "does not include the PartialApprovedFlag" do
        expect(request_body["Transaction"]["PartialApprovedFlag"]).to be_nil
      end
    end

    context "Card object" do
      it "is included" do
        expect(request_body["Card"]).not_to eq nil
      end

      it "includes ExpirationMonth" do
        expect(request_body["Card"]["ExpirationMonth"]).to eq "08"
      end

      it "includes ExpirationYear" do
        expect(request_body["Card"]["ExpirationYear"]).to eq "18"
      end
    end

    it "includes the PaymentAccountID" do
      expect(request_body["PaymentAccount"]["PaymentAccountID"]).to eq "paymentacct123"
    end
  end

  describe ".for_void" do
    subject(:request_body) do
      Vantiv::Api::RequestBody.for_void(
        transaction_id: "transactionid123"
      )
    end

    it "returns the expected body" do
      allow(SecureRandom).to receive(:hex).and_return "the-application-id"
      expected = {"Credentials"=>{"AcceptorID"=>"1166386"}, "Reports"=>{"ReportGroup"=>"1"}, "Application"=>{"ApplicationID"=>"the-application-id"}, "Transaction"=>{"TransactionID"=>"transactionid123"}}
      expect(request_body).to eq(expected)
    end

    it "includes the AcceptorID" do
      expect(request_body["Credentials"]["AcceptorID"]).to eq("1166386")
    end

    it "includes the default ReportGroup" do
      expect(request_body["Reports"]["ReportGroup"]).to eq("1")
    end

    it "include the ApplicationID" do
      expect(request_body["Application"]["ApplicationID"]).to be
    end

    it "includes the transaction id" do
      expect(request_body["Transaction"]["TransactionID"]).to eq("transactionid123")
    end
  end

  describe ".transaction_element" do
    def transaction_element
      transaction = Vantiv::Api::RequestBody.transaction_element(
        amount: 4224,
        customer_id: "some-cust",
        order_id: "some-order"
      )
      Vantiv::Api::RequestBody.new(transaction: transaction).run
    end

    it "includes a customer ID (required by Vantiv)" do
      expect(transaction_element["Transaction"]["CustomerID"]).to eq "some-cust"
    end

    it "includes the default order source" do
      expect(transaction_element["Transaction"]["OrderSource"]).to eq "ecommerce"
    end

    it "includes the merchant reference number for the order (required by Vantiv)" do
      expect(transaction_element["Transaction"]["ReferenceNumber"]).to eq "some-order"
    end
  end

end
