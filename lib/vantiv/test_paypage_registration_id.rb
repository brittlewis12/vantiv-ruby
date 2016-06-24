class TestPaypageRegistrationId

  def self.valid_registration_id
    MockedRegistrationId.new(
      "mocked-registration-id",
      "1111111111110009",
      Vantiv::TestCard.valid_account
    )
  end

  def self.expired_registration_id
    MockedRegistrationId.new(
      "RGFQNCt6U1d1M21SeVByVTM4dHlHb1FsVkUrSmpnWXhNY0o5UkMzRlZFanZiUHVnYjN1enJXbG1WSDF4aXlNcA==",
      "1111111111112222"
    )
  end

  class MockedRegistrationId
    attr_reader :mocked_sandbox_paypage_registration_id,
                :mocked_sandbox_payment_account_id, :test_card

    def initialize(mocked_sandbox_paypage_registration_id, mocked_sandbox_payment_account_id, test_card = nil)
      @mocked_sandbox_payment_account_id = mocked_sandbox_payment_account_id
      @mocked_sandbox_paypage_registration_id = mocked_sandbox_paypage_registration_id
      @test_card = test_card
    end
  end
end
