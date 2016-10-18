require 'vantiv'
require 'vantiv/certification/paypage_driver'
require 'vantiv/certification/response_cache'
require 'vantiv/certification/cert_request_body_compiler'

module Vantiv
  module Certification
    class ValidationTestRunner
      ENDPOINT_RESPONSE_OBJECT = {
        Api::Endpoints::TOKENIZATION => Api::TokenizationResponse.new,
        Api::Endpoints::AUTHORIZATION => Api::LiveTransactionResponse.new(:auth),
        Api::Endpoints::AUTH_REVERSAL => Api::TiedTransactionResponse.new(:auth_reversal),
        Api::Endpoints::CAPTURE => Api::TiedTransactionResponse.new(:capture),
        Api::Endpoints::SALE => Api::LiveTransactionResponse.new(:sale),
        Api::Endpoints::CREDIT => Api::TiedTransactionResponse.new(:credit),
        Api::Endpoints::RETURN => Api::TiedTransactionResponse.new(:return),
        Api::Endpoints::VOID => Api::TiedTransactionResponse.new(:void)
      }

      def self.run(save_to:, filter_by: '', use_xml: false)
        new(save_to: save_to, filter_by: filter_by, use_xml: use_xml).run
      end

      def initialize(save_to:, filter_by: '', use_xml: false)
        @certs_file = save_to
        @filter_by = filter_by
        @use_xml = use_xml
      end

      def run
        fixtures.each do |file_name|
          cert_name = get_cert_name(file_name)
          next if filter_by && !/#{filter_by}_\d*/.match(cert_name)

          contents = JSON.parse(File.read(file_name))
          run_request(
            cert_name: cert_name,
            endpoint: Vantiv::Api::Endpoints.const_get(contents["endpoint"]),
            body: create_body(contents["body"]),
            use_xml: @use_xml
          )
        end
        shutdown
      end

      private

      attr_reader :filter_by, :certs_file

      def create_body(base_body)
        compiled_base = request_body_compiler.compile(base_body)
        request_body = Vantiv::Api::RequestBody.new
        RequestBodyRepresenter.new(request_body).from_json(compiled_base.to_json)
      end

      def fixtures
        @fixtures ||= Dir.glob("#{Vantiv.root}/cert_fixtures/**/*")
      end

      def get_cert_name(file_name)
        /.*\/cert_fixtures\/(\w*).json/.match(file_name)[1]
      end

      def paypage_driver
        @paypage_driver ||= Vantiv::Certification::PaypageDriver.new.start
      end

      def response_cache
        @response_cache ||= Vantiv::Certification::ResponseCache.new
      end

      def results_file
        @results_file ||= File.open(certs_file, "w")
      end

      def request_body_compiler
        @request_body_compiler ||= CertRequestBodyCompiler.new(
          {
            regex: /.*\$\{eProtect\.(.*)\}.*/,
            fetcher: lambda do |value, match|
              value.gsub(
                /.*\$\{eProtect\.#{match}\}.*/,
                paypage_driver.get_paypage_registration_id(match)
              )
            end
          },
          {
            regex: /.*\#\{(.*)\}.*/,
            fetcher: lambda do |value, match|
              value.gsub(
                /\#\{#{match}\}/,
                  response_cache.access_value(match.split("."))
              )
            end
          }
        )
      end

      def shutdown
        paypage_driver.stop
        results_file.close
      end

      def run_request(cert_name:, endpoint:, body:, use_xml:)
        response = Vantiv::Api::Request.new(
          endpoint: endpoint,
          body: body,
          response_object: ENDPOINT_RESPONSE_OBJECT.fetch(endpoint),
          use_xml: use_xml
        ).run

        if response.api_level_failure?
          error_message = "CERT FAILED: #{cert_name} \n WITH: #{response.raw_body}"
          raise StandardError.new(error_message)
        end

        transaction_id = get_transaction_id(response, use_xml)

        response_cache.push(cert_name, response)
        results_file << "#{cert_name},#{transaction_id}\n"
      end

      def get_transaction_id(response, use_xml)
        if use_xml
          transaction_response_name = response.send(:transaction_response_name)
          transaction_response = response.body.send(transaction_response_name)
          transaction_response.transaction_id
        else
          response.body.request_id
        end
      end
    end
  end
end
