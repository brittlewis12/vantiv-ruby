module Vantiv
  class TestCard
    class CardNotFound < StandardError; end
    THIS_YEAR = Date.today.strftime("%y")
    LAST_YEAR = (Date.today << 12).strftime("%y")
    FOUR_YEARS_FROM_NOW = (Date.today >> 48).strftime("%y")
    LAST_CENTURY = "99"

    CARDS = [
      {
        access_method_name: "valid_account",
        attrs: {
          card_number: "4457010000000009",
          expiry_month: "01",
          expiry_year: THIS_YEAR,
          cvv: "349",
          mocked_sandbox_payment_account_id: "1111111111110009",
          network: "VI"
        }
      },
      {
        access_method_name: "invalid_card_number",
        attrs: {
          card_number: "4457010010900010",
          expiry_month: "01",
          expiry_year: THIS_YEAR,
          cvv: "349",
          mocked_sandbox_payment_account_id: nil,
          network: "VI"
        }
      },
      {
        access_method_name: "invalid_account_number",
        attrs: {
          card_number: "5112001600000006",
          expiry_month: "01",
          expiry_year: FOUR_YEARS_FROM_NOW,
          cvv: "349",
          mocked_sandbox_payment_account_id: "1111111111130006",
          network: "MC"
        }
      },
      {
        access_method_name: "insufficient_funds",
        attrs: {
          card_number: "4457002100000005",
          expiry_month: "01",
          expiry_year: FOUR_YEARS_FROM_NOW,
          cvv: "349",
          mocked_sandbox_payment_account_id: "1111111111120005",
          network: "VI"
        }
      },
      {
        access_method_name: "expired_card",
        attrs: {
          card_number: "5112001900000003",
          expiry_month: "01",
          expiry_year: FOUR_YEARS_FROM_NOW,
          cvv: "349",
          mocked_sandbox_payment_account_id: "1111111111140003",
          network: "MC"
        }
      },
      {
        access_method_name: "account_updater",
        attrs: {
          card_number: "4457000300000007",
          expiry_month: "01",
          expiry_year: LAST_YEAR,
          cvv: "123",
          mocked_sandbox_payment_account_id: "1111111111120007",
          network: "VI"
        }
      },
      {
        access_method_name: "account_updater_account_closed",
        attrs: {
          card_number: "5112000101110009",
          expiry_month: "11",
          expiry_year: LAST_CENTURY,
          cvv: "123",
          mocked_sandbox_payment_account_id: "1111111111160009",
          network: "MC"
        }
      },
      {
        access_method_name: "account_updater_contact_cardholder",
        attrs: {
          card_number: "4457000301100004",
          expiry_month: "11",
          expiry_year: LAST_CENTURY,
          cvv: "123",
          mocked_sandbox_payment_account_id: "1111111111130004",
          network: "VI"
        }
      },
    ]

    def self.all
      CARDS.map do |raw_card|
        new(raw_card[:attrs].merge(name: raw_card[:access_method_name]))
      end
    end

    CARDS.each do |raw_card|
      define_singleton_method :"#{raw_card[:access_method_name]}" do
        new(raw_card[:attrs].merge(name: raw_card[:access_method_name]))
      end
    end

    def self.find(card_number)
      card = CARDS.find do |card_data|
        card_data[:attrs][:card_number] == card_number
      end
      raise CardNotFound.new("No card with account number #{card_number}") unless card
      new(card[:attrs].merge(name: card[:access_method_name]))
    end

    def self.find_by_payment_account_id(payment_account_id)
      card = CARDS.find do |card_data|
        card_data[:attrs][:mocked_sandbox_payment_account_id] == payment_account_id
      end
      raise CardNotFound.new("No card with mocked sandbox payment account id #{payment_account_id}") unless card
      new(card[:attrs].merge(name: card[:access_method_name]))
    end

    attr_reader :card_number, :expiry_month, :expiry_year, :cvv, :mocked_sandbox_payment_account_id, :network, :name

    def initialize(card_number:, expiry_month:, expiry_year:, cvv:, mocked_sandbox_payment_account_id:, network:, name:)
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
