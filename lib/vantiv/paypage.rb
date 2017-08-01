module Vantiv
  module Paypage
    def self.root_uri
      if Vantiv::Environment.production?
        "https://request.eprotect.vantivcnp.com"
      elsif Vantiv::Environment.postcertification?
        "https://request.eprotect.vantivpostlive.com"
      else
        "https://request.eprotect.vantivprelive.com"
      end
    end

    def self.api_js
      "#{root_uri}/eProtect/litle-api2.js"
    end

    def self.jquery_js
      "#{root_uri}/eProtect/js/jquery-1.11.2.min.js"
    end

    def self.payframe_js
      "#{root_uri}/eProtect/js/payframe-client.min.js"
    end
  end
end
