class Api::V1::MerchantsController < ApplicationController

  def index
    merchants = Merchant.all
    serialized = MerchantSerializer.new(merchants)
    render json: serialized
  end

  def show
    merchant = Merchant.find(params[:id])
    serialized = MerchantSerializer.new(merchant)
    render json: serialized
  end

end
