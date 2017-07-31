module Vantiv
  module Paypage
    def self.root_uri
      if use_vantiv_rebrand_urls?
        if Vantiv::Environment.production?
          "https://request.eprotect.vantivcnp.com"
        elsif Vantiv::Environment.postcertification?
          "https://request.eprotect.vantivpostlive.com"
        else
          "https://request.eprotect.vantivprelive.com"
        end
      else
        if Vantiv::Environment.production?
          "https://request.securepaypage-litle.com"
        elsif Vantiv::Environment.postcertification?
          "https://request-postlive.np-securepaypage-litle.com"
        else
          "https://request-prelive.np-securepaypage-litle.com"
        end
      end
    end

    def self.api_js
      if use_vantiv_rebrand_urls?
        "#{root_uri}/eProtect/litle-api2.js"
      else
        "#{root_uri}/LitlePayPage/litle-api2.js"
      end
    end

    def self.jquery_js
      if use_vantiv_rebrand_urls?
        "#{root_uri}/eProtect/js/jquery-1.11.2.min.js"
      else
        "#{root_uri}/LitlePayPage/js/jquery-1.11.2.min.js"
      end
    end

    def self.payframe_js
      if use_vantiv_rebrand_urls?
        "#{root_uri}/eProtect/js/payframe-client.min.js"
      else
        "#{root_uri}/LitlePayPage/js/payframe-client.min.js"
      end
    end

    private_class_method def self.use_vantiv_rebrand_urls?
      !ENV.fetch("ENABLE_VANTIV_LITLE_MIGRATION", "").empty?
    end
  end
end
