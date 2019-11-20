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
    merchant = Merchant.where("#{params.keys.first} = '#{params.values.first.gsub(/'/, '%')}'")
    serialized = MerchantSerializer.new(merchant)
    render json: serialized
  end

  def find_all
    merchants = Merchant.having("#{params.keys.first} = '#{params.values.first.gsub(/'/, '%')}'").group(:id)
    serialized = MerchantSerializer.new(merchants)
    render json: serialized
  end

  def random
    merchant = Merchant.order('RANDOM()').first
    serialized = MerchantSerializer.new(merchant)
    render json: serialized
  end


  private

  def merchant_params
    params.require(:merchant).permit(Merchant.column_names)
  end
end
