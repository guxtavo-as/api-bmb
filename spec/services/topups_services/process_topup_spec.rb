require 'rails_helper'

RSpec.describe TopupsServices::ProcessTopup do
  let(:topup) { create(:topup, status: :paid) }

  before do
    allow_any_instance_of(ProviderServices::TopupProviderClient)
      .to receive(:call)
      .and_return({ provider_reference: "OK123", foo: "bar" })
  end

  it "updates topup on success" do
    service = described_class.new(topup).call

    expect(service.success?).to be true
    expect(service.provider_reference).to eq("OK123")
    expect(service.response_payload).to include(:foo)
  end

  it "handles provider errors" do
    allow_any_instance_of(ProviderServices::TopupProviderClient)
      .to receive(:call)
      .and_raise(
        ProviderServices::Errors::ProviderInvalidError.new("Invalid", {})
      )

    service = described_class.new(topup).call

    expect(service.success?).to be false
    expect(service.retryable).to be false
    expect(service.errors).to eq("Invalid")
  end
end
