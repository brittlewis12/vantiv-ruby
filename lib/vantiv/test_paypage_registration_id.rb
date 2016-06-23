class TestPaypageRegistrationId

  def self.valid_registration_id
    MockedRegistrationId.new(
      "mocked-registration-id",
      "1111111111110009",
      Vantiv::TestCard.valid_account
    )
  end

  def self.expired_registration_id
    "RGFQNCt6U1d1M21SeVByVTM4dHlHb1FsVkUrSmpnWXhNY0o5UkMzRlZFanZiUHVnYjN1enJXbG1WSDF4aXlNcA=="
  end

  def self.all
    [valid_registration_id]#, expired_registration_id]
  end

  class MockedRegistrationId
    attr_reader :mocked_sandbox_paypage_registration_id,
                :mocked_sandbox_payment_account_id, :test_card

    def initialize(mocked_sandbox_paypage_registration_id, mocked_sandbox_payment_account_id, test_card)
      @mocked_sandbox_payment_account_id = mocked_sandbox_payment_account_id
      @mocked_sandbox_paypage_registration_id = mocked_sandbox_paypage_registration_id
      @test_card = test_card
    end
  end
end
