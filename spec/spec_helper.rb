require 'vantiv'

require 'dotenv'
Dotenv.load
Dir["#{Vantiv.root}/spec/support/**/*.rb"].each {|f| require f}

Vantiv.configure do |config|
  config.environment = Vantiv::Environment::PRECERTIFICATION
  config.merchant_id = ENV["MERCHANT_ID"]
  config.default_order_source = "ecommerce"
  config.paypage_id = ENV["PAYPAGE_ID"]

  config.user = ENV["VANTIV_USER"]
  config.password = ENV["VANTIV_PASSWORD"]

  config.default_report_group = '1'
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end

if ENV["LOG_REQUESTS"] == "true"
  require "logger"

  logger = Logger.new(STDERR)
  logger.formatter = proc { |_severity, _time, _progname, msg| msg }
  RequestLogger.set_logger(logger)
  Vantiv::Api::Request.prepend(RequestLogger)
end
