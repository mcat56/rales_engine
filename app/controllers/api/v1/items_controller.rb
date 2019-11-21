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

  def find
    item = Item.where(item_params).first
    serialized = ItemSerializer.new(item)
    render json: serialized
  end

  def find_all
    items = Item.having(item_params).group(:id).order(:id)
    serialized = ItemSerializer.new(items)
    render json: serialized
  end

  def random
    item = Item.order('RANDOM()').first
    serialized = ItemSerializer.new(item)
    render json: serialized
  end


  private

  def item_params
    if params['name']
      params['name'].gsub(/'/, '%27')
    end 
    params.permit(:id, :name, :description, :unit_price, :updated_at, :created_at)
  end

end
