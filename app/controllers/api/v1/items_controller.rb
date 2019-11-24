class Api::V1::ItemsController < ApplicationController

  def index
    items = Item.all
    serialized = ItemSerializer.new(items)
    render json: serialized
  end

  def show
    item = Item.find(params[:id])
    serialized = ItemSerializer.new(item)
    render json: serialized
  end

end
