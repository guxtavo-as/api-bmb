module ProviderServices
  class TopupProviderClient
    PROVIDER_URL = ENV['PROVIDER_URL']

    def initialize(topup)
      @topup = topup
    end

    def call
      @conn = connection
      response = @conn.post do |req|
        req.body = payload_body
        req.options.timeout = 35
        req.options.open_timeout = 20
      end

      response_handle(response)
    rescue Faraday::TimeoutError, Faraday::ConnectionFailed => e
      raise Errors::ProviderTimeoutError.new('Provider timeout', response: nil)
    end

    private

    def connection
      Faraday.new(url: PROVIDER_URL) do |c|
        c.request :json
        c.response :logger
        c.response :json, parser_options: { symbolize_names: true }
        c.adapter Faraday.default_adapter
      end
    end

    def payload_body
      {
        product_id: @topup['request_payload']['product']['id'],
        phone_number: @topup['phone_number'],
        amount: @topup.amount,
        unit: @topup['request_payload']['product']['unit'],
        external_id: @topup.external_id,
        customer_id: @topup['request_payload']['customer']['id']
      }.to_json
    end

    def response_handle(response)
      case response.status
      when 200
        response.body
      when 422
        raise Errors::ProviderInvalidError.new('Invalid request', response.body)
      when 500..599
        error = Errors::ProviderError.new('Provider Server Error', response.body)
        def error.retryable?; true; end
        raise error
      else
        error = Errors::ProviderError.new("Unexpected Status: #{response.status}", response.body)
        def error.retryable?; false; end
        raise error
      end
    end
  end
end
