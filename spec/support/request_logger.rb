module RequestLogger
  def self.set_logger(logger)
    @@logger = logger
  end

  private

  def send_request(request)
    log_request(request)
    super.tap(&method(:log_response))
  end

  def log_request(request)
    @@logger.info do
      headers = request.each_header
        .sort_by(&:first)
        .map { |h| "#{h.first}: #{h.last}"}

      message = <<~INFO
      ****************** START REQUEST ******************
      sent_at: #{Time.now.iso8601}
      uri: #{request.path}
      headers:
      #{headers.map { |h| "\t#{h}" }.join("\n")}
      body:
      #{request.body}
      ******************* END REQUEST *******************
      INFO

      message
        .gsub(/<password>[^<>]*<\/password>/, "<password>REDACTED</password>")
        .gsub(/\bmerchantId="\d+"/, 'merchantId="REDACTED"')
    end
  end

  def log_response(response)
    @@logger.info do
      headers = response.each_header
        .sort_by(&:first)
        .map { |h| "#{h.first}: #{h.last}"}

      <<~INFO
      ****************** START RESPONSE ******************
      received_at: #{Time.now.iso8601}
      code: #{response.code}
      headers:
      #{headers.map { |h| "\t#{h}" }.join("\n")}
      body:
      #{response.body}
      ******************* END RESPONSE *******************
      INFO
    end
  end
end
