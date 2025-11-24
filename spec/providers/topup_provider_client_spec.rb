require 'rails_helper'
ENV['PROVIDER_URL'] = 'https://topup-platform-product-provider.onrender.com/provider/topup'

RSpec.describe ProviderServices::TopupProviderClient do
  let(:topup) { create(:topup) }
  let(:client) { described_class.new(topup) }

  before do
    stub_request(:post, ENV["PROVIDER_URL"])
      .to_return(
        status: 200,
        body: { provider_reference: "ABC" }.to_json,
        headers: { "Content-Type" => "application/json" }
      )
  end

  it "sends request to provider and parses correctly" do
    result = client.call
    expect(result[:provider_reference]).to eq("ABC")
  end
end
