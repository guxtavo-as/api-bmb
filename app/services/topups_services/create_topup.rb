module TopupsServices
  class CreateTopup
    attr_reader :topup, :errors, :http_status

    def initialize(params)
      @external_id = params['external_id']
      @phone_number = params['phone_number']
      @amount = params['product']['amount']
      @params = params
      @errors = []
    end

    def success?
      @errors.blank?
    end

    def call
      @errors << I18n.t('errors.messages.external_id_not_blank') if @external_id.blank?
      @errors << I18n.t('errors.messages.phone_number_not_blank') if @phone_number.blank?
      @errors << I18n.t('errors.messages.amount_not_blank') if @amount.blank?

      return self unless @errors.blank?

      @topup = create_or_fetch_topup!

      TopupsJobs::ProcessTopupJob.perform_async(@topup.id, @topup.phone_number) if @topup.paid?

      self
    rescue ActiveRecord::RecordNotUnique
      exist = Topup.find_by(external_id: @external_id)
      return exist if exist

      @errors << I18n.t('errors.messages.idempotency_conflict')
      self
    rescue StandardError => e
      @errors << I18n.t('errors.messages.unexpected_error', error: e.message)
      self
    end

    private

    def create_or_fetch_topup!
      Topup.create!(
        external_id: @external_id,
        phone_number: @phone_number,
        amount: @amount,
        request_payload: @params,
        status: @params['status']
      )
    end
  end
end
