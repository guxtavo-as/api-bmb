module ProviderServices
  module Errors
    class ProviderInvalidError < ProviderError
      def retryable?
        false
      end
    end
  end
end
