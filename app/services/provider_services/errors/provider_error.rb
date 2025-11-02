module ProviderServices
  module Errors
    class ProviderError < StandardError
      attr_reader :response

      def initialize(message = nil, response = nil)
        super(message)
        @response = response
      end

      def retryable?
        false
      end
    end
  end
end
