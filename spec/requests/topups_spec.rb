require 'rails_helper'

RSpec.describe "Topups API", type: :request do
  describe "POST /topups" do
    let(:valid_params) do
      {
        external_id: "abc123",
        phone_number: "5511999999999",
        status: "paid",
        product: {
          id: 10,
          unit: "BRL",
          amount: 50
        },
        customer: {
          id: 22
        }
      }
    end

    it "creates a new topup and returns accepted" do
      expect {
        post "/topups", params: valid_params, as: :json
      }.to change(Topup, :count).by(1)

      expect(response).to have_http_status(:accepted)

      body = JSON.parse(response.body)
      expect(body["external_id"]).to eq("abc123")
      expect(body["status"]).to eq("paid")
    end

    it "returns errors when parameters are missing" do
      post "/topups", params: {}, as: :json

      expect(response.status).to eq(422)

      body = JSON.parse(response.body)
      expect(body["error"]).to be_present
    end
  end

  describe "GET /topups/:id" do
    let(:topup) { create(:topup) }

    before do
      topup
    end

    it "returns an existing topup" do
      get "/topups/#{topup.id}"

      pp response
      expect(response).to have_http_status(200)
      body = JSON.parse(response.body)

      expect(body["id"]).to eq(topup.id)
      expect(body["external_id"]).to eq(topup.external_id)
    end
  end
end
