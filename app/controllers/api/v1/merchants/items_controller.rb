class Api::V1::Merchants::ItemsController < ApplicationController

  def index
    merchant = Merchant.find(params[:merchant_id])
    items = merchant.items
    serialized = ItemSerializer.new(items)
    render json: serialized
  end

end
