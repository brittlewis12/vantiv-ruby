module Vantiv
  module Paypage
    def self.root_uri
      if Vantiv::Environment.production?
        "https://request.securepaypage-litle.com"
      elsif Vantiv::Environment.postcertification?
        "https://request-postlive.np-securepaypage-litle.com"
      else
        "https://request-prelive.np-securepaypage-litle.com"
      end
    end

    def self.api_js
      "#{root_uri}/LitlePayPage/litle-api2.js"
    end

    def self.jquery_js
      "#{root_uri}/LitlePayPage/js/jquery-1.11.2.min.js"
    end

    def self.payframe_js
      "#{root_uri}/LitlePayPage/js/payframe-client.min.js"
    end
  end
end
