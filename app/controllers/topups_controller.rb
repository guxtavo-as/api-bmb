class TopupsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

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
    params.permit!
  end
end
