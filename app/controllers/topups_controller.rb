class TopupsController < ApplicationController
  def show
    topup = Topup.find(params[:id])

    render json: topup, serializer: TopupSerializer
  end

  def create
    service = TopupsServices::CreateTopup.new(topup_params).call

    if service.success?
      render json: service.topup, serializer: TopupSerializer, status: :accepted
    else
      render json: { error: service.errors }, status: :unprocessable_content
    end
  end

  private

  def topup_params
    params.permit(
      :external_id,
      :phone_number,
      :status,
      product: [:id, :unit, :amount],
      customer: [:id]
    ).to_h.symbolize_keys
  end
end
