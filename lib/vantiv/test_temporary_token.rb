module Vantiv
  class Vantiv::TestTemporaryToken

    def self.valid_temporary_token
      "mocked-valid-temporary-token"
    end

    def self.expired_temporary_token
      "RGFQNCt6U1d1M21SeVByVTM4dHlHb1FsVkUrSmpnWXhNY0o5UkMzRlZFanZiUHVnYjN1enJXbG1WSDF4aXlNcA=="
    end

    def self.invalid_temporary_token
      "pDZJcmd1VjNlYXNaSlRMTGpocVZQY1NWVXE4Z W5UTko4NU9KK3p1L1p1Vzg4YzVPQVlSUHNITG1 JN2I0NzlyTg=="
    end

    def self.all
      [invalid_temporary_token, expired_temporary_token, valid_temporary_token]
    end
  end
end
