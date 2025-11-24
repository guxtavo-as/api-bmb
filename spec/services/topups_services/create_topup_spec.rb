require 'rails_helper'

RSpec.describe TopupsServices::CreateTopup do
  let(:params) do
    {
      external_id: SecureRandom.uuid,
      phone_number: "5511999999999",
      status: :paid,
      product: { amount: 10 }
    }
  end
  let(:params2) do
    {
      external_id: "abc123",
      phone_number: "5511999999999",
      status: :paid,
      product: { amount: 10 }
    }
  end

  subject(:service) { described_class.new(params) }

  it "creates a topup when params are valid" do
    result = service.call

    expect(result.success?).to be true
    expect(result.topup).to be_persisted
  end

  it "returns errors when missing required fields" do
    invalid = described_class.new({})
    result = invalid.call

    expect(result.success?).to be false
    expect(result.errors).to be_present
  end

  it "does not create two topups with same external_id" do
    create(:topup, external_id: "abc123")

    result = described_class.new(params2).call

    expect(result.success?).to be false
    expect(result.errors).to include(I18n.t('errors.messages.idempotency_conflict'))
  end
end
