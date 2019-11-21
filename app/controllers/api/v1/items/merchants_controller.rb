class Api::V1::Items::MerchantsController < ApplicationController

  def show
    item = Item.find(params[:item_id])
    merchant = item.merchant
    serialized = MerchantSerializer.new(merchant)
    render json: serialized
  end
  
end
