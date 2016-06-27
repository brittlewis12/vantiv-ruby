class TestPaypageRegistrationId

  def self.valid_registration_id
    "mocked-registration-id"
  end

  def self.expired_registration_id
    "RGFQNCt6U1d1M21SeVByVTM4dHlHb1FsVkUrSmpnWXhNY0o5UkMzRlZFanZiUHVnYjN1enJXbG1WSDF4aXlNcA=="
  end

  def self.invalid_registration_id
    "pDZJcmd1VjNlYXNaSlRMTGpocVZQY1NWVXE4Z W5UTko4NU9KK3p1L1p1Vzg4YzVPQVlSUHNITG1 JN2I0NzlyTg=="
  end

  def self.all
    [invalid_registration_id, expired_registration_id, valid_registration_id]
  end
end
