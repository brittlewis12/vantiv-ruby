require 'representable/json'
require 'vantiv/api/response_body_representer'
require 'vantiv/api/response_body'

class MockedResponseRepresenter < Representable::Decorator
  include Representable::JSON

  property :httpok
  property :http_response_code
  property :body, decorator: ResponseBodyRepresenter, class: Vantiv::Api::ResponseBody
end
