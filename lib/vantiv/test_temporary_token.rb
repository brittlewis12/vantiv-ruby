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

    def self.apple_pay_temporary_token
      "VjRlMDJxWWVqNTN3d1pWR0VPN1pQVmN6cTR1YWcvWitReCtWUE4xT0J2ZjBRQmtCU3dVV1V3ckIzVEJkNHlUM0krZnUvcXlRenhNeit0ZkM1SEx3TVpzMUQ4Z0o0WkZSdVVibUF1Q1pwNE1WNUxhcXIraU9saE9oNVE5N3p6K1BWcEZrVnJQekVCTFNEQndXcEVsWUpnK0VYby9zMGNYUENEOXFIbC9tQjQ4PQ=="
    end

    def self.all
      [invalid_temporary_token, expired_temporary_token, valid_temporary_token, apple_pay_temporary_token]
    end
  end
end
