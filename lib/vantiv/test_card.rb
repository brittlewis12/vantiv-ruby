module Vantiv
  class TestCard
    class CardNotFound < StandardError; end
    CARDS = [
      {
        name: "valid_account",
        card_number: "4457010000000009",
        expiry_month: "01",
        expiry_year: "21",
        cvv: "349",
        mocked_sandbox_payment_account_id: "1111111111110009",
        network: "VI"
      },
      {
        name: "invalid_card_number",
        card_number: "4457010010900010",
        expiry_month: "01",
        expiry_year: "21",
        cvv: "349",
        mocked_sandbox_payment_account_id: nil,
        network: "VI"
      },
      {
        name: "invalid_account_number",
        card_number: "5112001600000006",
        expiry_month: "01",
        expiry_year: "20",
        cvv: "349",
        mocked_sandbox_payment_account_id: "1111111111130006",
        network: "MC"
      },
      {
        name: "insufficient_funds",
        card_number: "4457002100000005",
        expiry_month: "01",
        expiry_year: "20",
        cvv: "349",
        mocked_sandbox_payment_account_id: "1111111111120005",
        network: "VI"
      },
      {
        name: "expired_card",
        card_number: "5112001900000003",
        expiry_month: "01",
        expiry_year: "20",
        cvv: "349",
        mocked_sandbox_payment_account_id: "1111111111140003",
        network: "MC"
      },
      {
        name: "account_updater",
        card_number: "4457000300000007",
        expiry_month: "01",
        expiry_year: "15",
        cvv: "123",
        mocked_sandbox_payment_account_id: "1111111111120007",
        network: "VI"
      },
      {
        name: "account_updater_account_closed",
        card_number: "5112000101110009",
        expiry_month: "11",
        expiry_year: "99",
        cvv: "123",
        mocked_sandbox_payment_account_id: "1111111111160009",
        network: "MC"
      },
      {
        name: "account_updater_contact_cardholder",
        card_number: "4457000301100004",
        expiry_month: "11",
        expiry_year: "99",
        cvv: "123",
        mocked_sandbox_payment_account_id: "1111111111130004",
        network: "VI"
      },
    ]

    CARDS.each do |card|
      card[:temporary_token] = card[:name].tr("_", "-") + "-token"
      card.freeze
    end

    CARDS.freeze

    def self.all
      CARDS.map do |raw_card|
        new(raw_card)
      end
    end

    CARDS.each do |raw_card|
      define_singleton_method raw_card[:name] do
        new(raw_card)
      end
    end

    def self.find(card_number)
      card = CARDS.find do |card_data|
        card_data[:card_number] == card_number
      end
      raise CardNotFound.new("No card with account number #{card_number}") unless card
      new(card)
    end

    def self.find_by_payment_account_id(payment_account_id)
      card = CARDS.find do |card_data|
        card_data[:mocked_sandbox_payment_account_id] == payment_account_id
      end
      raise CardNotFound.new("No card with mocked sandbox payment account id #{payment_account_id}") unless card
      new(card)
    end

    attr_reader :card_number, :expiry_month, :expiry_year, :cvv, :mocked_sandbox_payment_account_id, :network, :name, :temporary_token

    def initialize(card_number:, expiry_month:, expiry_year:, cvv:, mocked_sandbox_payment_account_id:, network:, name:, temporary_token:)
      @card_number = card_number
      @expiry_month = expiry_month
      @expiry_year = expiry_year
      @cvv = cvv
      @mocked_sandbox_payment_account_id = mocked_sandbox_payment_account_id
      @network = network
      @name = name
      @temporary_token = temporary_token
    end

    def ==(other_object)
      if other_object.is_a?(TestCard)
        name == other_object.name
      else
        super
      end
    end

    def !=(other_object)
      !(self == other_object)
    end

    def tokenizable?
      self != TestCard.invalid_card_number
    end
  end
end
