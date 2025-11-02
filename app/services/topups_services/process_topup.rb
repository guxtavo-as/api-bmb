module TopupsServices
  class ProcessTopup
    attr_reader :errors, :retryable, :provider_reference, :response_payload

    def initialize(topup)
      @topup = topup
      @provider_reference = nil
      @response_payload = {}
      @retryable = false
      @errors = []
    end

    def success?
      @errors.blank?
    end

    def call
      response = ProviderServices::TopupProviderClient.new(@topup).call

      @provider_reference = response[:provider_reference] || response['provider_reference']
      @retryable = false
      @response_payload = response

      self
    rescue ProviderServices::Errors::ProviderError => e
      @provider_reference = nil
      @retryable = e.retryable?
      @response_payload = e.response
      @errors = e.message

      self
    end
  end
end
