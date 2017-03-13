module Vantiv
  module Environment
    POSTCERTIFICATION = :postcertification
    PRECERTIFICATION = :precertification
    PRODUCTION = :production

    def self.postcertification?
      Vantiv.environment == POSTCERTIFICATION
    end

    def self.precertification?
      Vantiv.environment == PRECERTIFICATION
    end

    def self.production?
      Vantiv.environment == PRODUCTION
    end
  end
end
