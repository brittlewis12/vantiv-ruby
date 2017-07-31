module Vantiv
  class TestCard
    class CardNotFound < StandardError; end
    CARDS = [
      {
        name: "account_updater",
        card_number: "4457000300000007",
        expiry_month: "01",
        expiry_year: "15",
        cvv: "123",
        mocked_sandbox_payment_account_id: "1111111111120007",
        network: "VI",
      },
      {
        name: "account_updater_account_closed",
        card_number: "5112000101110009",
        expiry_month: "11",
        expiry_year: "99",
        cvv: "123",
        mocked_sandbox_payment_account_id: "1111111111160009",
        network: "MC",
      },
      {
        name: "account_updater_contact_cardholder",
        card_number: "4457000301100004",
        expiry_month: "11",
        expiry_year: "99",
        cvv: "123",
        mocked_sandbox_payment_account_id: "1111111111130004",
        network: "VI",
      },
      {
        name: "expired_card",
        card_number: "5112001900000003",
        expiry_month: "01",
        expiry_year: "20",
        cvv: "349",
        mocked_sandbox_payment_account_id: "1111111111140003",
        network: "MC",
      },
#      {
#        name: "insufficient_funds",
#        card_number: "4457002100000005",
#        expiry_month: "01",
#        expiry_year: "20",
#        cvv: "349",
#        mocked_sandbox_payment_account_id: "1111111111120005",
#        network: "VI",
#      },
      {
        name: "insufficient_funds",
        card_number: "4457010100000008",
        expiry_month: "06",
        expiry_year: "21",
        cvv: "992",
        mocked_sandbox_payment_account_id: "1111111111120008",
        network: "VI",
      },
#      {
#        name: "invalid_account_number",
#        card_number: "5112001600000006",
#        expiry_month: "01",
#        expiry_year: "20",
#        cvv: "349",
#        mocked_sandbox_payment_account_id: "1111111111130006",
#        network: "MC",
#      },
      {
        name: "invalid_account_number",
        card_number: "5112010100000002",
        expiry_month: "07",
        expiry_year: "21",
        cvv: "251",
        mocked_sandbox_payment_account_id: "1111111111130002",
        network: "MC",
      },
      {
        name: "invalid_card_number",
        card_number: "4457010010900010",
        expiry_month: "01",
        expiry_year: "21",
        cvv: "349",
        mocked_sandbox_payment_account_id: nil,
        network: "VI",
      },
      {
        name: "pick_up_card",
        card_number: "375001010000003",
        expiry_month: "09",
        expiry_year: "21",
        cvv: "0421",
        mocked_sandbox_payment_account_id: "1111111111120003",
        network: "AX",
      },
      {
        name: "valid_account",
        card_number: "4747474747474747",
        expiry_month: "01",
        expiry_year: "21",
        cvv: "123",
        mocked_sandbox_payment_account_id: "1111111111114747",
        network: "VI",
      },
      {
        name: "valid_account_amex",
        card_number: "375001000000005",
        expiry_month: "04",
        expiry_year: "21",
        cvv: "758",
        mocked_sandbox_payment_account_id: "111111111160005",
        network: "VI",
      },
      {
        name: "valid_account_discover",
        card_number: "6011010000000003",
        expiry_month: "03",
        expiry_year: "21",
        cvv: "758",
        mocked_sandbox_payment_account_id: "1111111111150003",
        network: "VI",
      },
      {
        name: "valid_account_mastercard",
        card_number: "5112010000000003",
        expiry_month: "02",
        expiry_year: "21",
        cvv: "261",
        mocked_sandbox_payment_account_id: "1111111111130003",
        network: "VI",
      },
      {
        name: "valid_account_visa",
        card_number: "4457010000000009",
        expiry_month: "01",
        expiry_year: "21",
        cvv: "349",
        mocked_sandbox_payment_account_id: "1111111111110009",
        network: "VI",
      },
    ].freeze

    CARDS.each do |raw_card|
      define_singleton_method raw_card[:name] do
        new(raw_card)
      end
    end

    def self.all
      CARDS.map { |raw_card| send(raw_card[:name]) }
    end

    def self.find(card_number)
      card = CARDS.find do |card_data|
        card_data[:card_number] == card_number
      end
      raise CardNotFound.new("No card with account number #{card_number}") unless card
      send(card[:name])
    end

    def self.find_by_payment_account_id(payment_account_id)
      card = CARDS.find do |card_data|
        card_data[:mocked_sandbox_payment_account_id] == payment_account_id
      end
      raise CardNotFound.new("No card with mocked sandbox payment account id #{payment_account_id}") unless card
      send(card[:name])
    end

    attr_reader *%i(
      card_number
      cvv
      expiry_month
      expiry_year
      mocked_sandbox_payment_account_id
      name
      network
    )

    def initialize(
      card_number:,
      cvv:,
      expiry_month:,
      expiry_year:,
      mocked_sandbox_payment_account_id:,
      name:,
      network:
    )
      @card_number = card_number
      @expiry_month = expiry_month
      @expiry_year = expiry_year
      @cvv = cvv
      @mocked_sandbox_payment_account_id = mocked_sandbox_payment_account_id
      @network = network
      @name = name
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
