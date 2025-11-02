module TopupsJobs
  class ProcessTopupJob < ApplicationJob
    sidekiq_options queue: :critical, retry: 3
    sidekiq_throttle(concurrency: { limit: 1, key_suffix: ->(_topup_id, phone) { phone } })

    def perform(topup_id, phone)
      topup = Topup.find(topup_id)
      return if topup.success? || topup.failed?

      topup.mark_processing!
      result = TopupsServices::ProcessTopup.new(topup).call

      if result.success?
        topup.mark_success!(result.provider_reference, result.response_payload)
      else
        if result.retryable
          raise result.errors
        else
          topup.mark_failed!(result.errors, result.response_payload)
        end
      end
    rescue ActiveRecord::RecordNotFound
      Rails.logger.warn "Topup not found: #{topup}"
    end
  end
end
