module ProviderServices
  module Errors
    class ProviderTimeoutError < ProviderError
      def retryable?
        true
      end
    end
  end
end
