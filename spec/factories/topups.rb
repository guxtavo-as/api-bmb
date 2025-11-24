FactoryBot.define do
  factory :topup do
    external_id { SecureRandom.uuid }
    phone_number { "5511999999999" }
    amount { 10.0 }
    status { :paid }
    request_payload do
      {
        "product" => { "id" => 1, "amount" => 10, "unit" => "BRL" },
        "customer" => { "id" => 20 }
      }
    end
    response_payload { {} }
  end
end
