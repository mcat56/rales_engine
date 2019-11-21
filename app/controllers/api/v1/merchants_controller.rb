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

  def find
    merchant = Merchant.where("#{params.keys.first} = '#{params.values.first.gsub(/'/, '%27')}'").first
    serialized = MerchantSerializer.new(merchant)
    render json: serialized
  end

  def find_all
    merchants = Merchant.having("#{params.keys.first} = '#{params.values.first.gsub(/'/, '%27')}'").group(:id)
    serialized = MerchantSerializer.new(merchants)
    render json: serialized
  end

  def random
    merchant = Merchant.order('RANDOM()').first
    serialized = MerchantSerializer.new(merchant)
    render json: serialized
  end

  def top_merchants
    top_merchants = Merchant.top_merchants(params[:quantity].to_i)
    serialized = MerchantSerializer.new(top_merchants)
    render json: serialized
  end

  private

  def merchant_params
    params.require(:merchant).permit(:id, :name, :created_at, :updated_at)
  end

end
