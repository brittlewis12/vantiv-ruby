module Vantiv
  module Certification
    class ResponseCache
      def initialize
        @responses = {}
      end

      def push(cert_name, response)
        @responses[cert_name] = response
      end

      def access_value(values_tree)
        cert_name = values_tree.shift
        response = @responses[cert_name]
        method_chain = values_tree.join('.')
        p response
        response.instance_eval(method_chain)
      end
    end

  end
end
