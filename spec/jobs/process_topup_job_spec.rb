require 'rails_helper'
require 'sidekiq/testing'

Sidekiq::Testing.fake!

RSpec.describe TopupsJobs::ProcessTopupJob, type: :job do
  let(:topup) { create(:topup, status: :paid) }

  before do
    allow_any_instance_of(ProviderServices::TopupProviderClient)
      .to receive(:call)
      .and_return({ provider_reference: "OK123" })
  end

  it "queues job" do
    expect {
      described_class.perform_async(topup.id, topup.phone_number)
    }.to change(described_class.jobs, :size).by(1)
  end

  it "processes a topup successfully" do
    described_class.new.perform(topup.id, topup.phone_number)

    topup.reload
    expect(topup.status).to eq("success")
  end
end
