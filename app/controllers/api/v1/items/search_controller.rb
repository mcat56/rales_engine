class Api::V1::Items::SearchController < ApplicationController

  def show
    item = Item.where(item_params).first
    serialized = ItemSerializer.new(item)
    render json: serialized
  end

  def index
    items = Item.having(item_params).group(:id).order(:id)
    serialized = ItemSerializer.new(items)
    render json: serialized
  end

  def random
    item = Item.order('RANDOM()').first
    serialized = ItemSerializer.new(item)
    render json: serialized
  end

  def top_items
    count = params[:quantity]
    top_items = Item.top_items(count)
    serialized = ItemSerializer.new(top_items)
    render json: serialized
  end

  def best_day
    item = Item.find(params[:item_id])
    best_day = item.best_day
    serialized = DatesFacade.new(best_day)
    render json: serialized.data
  end

  private

  def item_params
    if params['name']
      params['name'].gsub(/'/, '%27')
    end
    params.permit(:id, :name, :description, :unit_price, :merchant_id, :updated_at, :created_at)
  end

end
