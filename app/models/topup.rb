class Topup < ApplicationRecord
  acts_as_paranoid

  enum status: { paid: 0, processing: 1, success: 2, failed: 3 }

  validates :external_id, presence: true, uniqueness: { case_sensitive: true }
  validates :phone_number, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }

  # Garantir que os payloads sejam hashes nil_safe
  before_validation :ensure_payloads_are_hashes

  scope :paid_or_processing, -> { where(status: [:paid, :processing]) }

  def mark_processing!
    update(status: :processing)
  end

  def mark_success!(provider_reference, response_payload)
    update(status: :success, provider_reference: provider_reference, response_payload: response_payload)
  end

  def mark_failed!(error_message, response_payload)
    update(status: :failed, error_message: error_message, response_payload: response_payload)
  end

  private

  def ensure_payloads_are_hashes
    self.request_payload ||= {}
    self.response_payload ||= {}
  end
end
