class TopupSerializer < ActiveModel::Serializer
  attributes :id, :external_id, :status, :phone_number, :amount,
             :provider_reference, :request_payload, :response_payload,
             :created_at, :updated_at, :deleted_at, :error_message
end