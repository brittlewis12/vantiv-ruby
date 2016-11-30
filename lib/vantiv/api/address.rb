module Vantiv
  module Api
    class Address
      attr_accessor *%i(
        billing_address_1
        billing_address_2
        billing_city
        billing_country
        billing_name
        billing_state
        billing_zipcode
      )
    end
  end
end
