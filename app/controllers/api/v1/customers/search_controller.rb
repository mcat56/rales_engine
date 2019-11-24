class Api::V1::Customers::SearchController < ApplicationController

  def show
    customer = Customer.where(customer_params).first
    serialized = CustomerSerializer.new(customer)
    render json: serialized
  end

  def index
    customers = Customer.having(customer_params).group(:id)
    serialized = CustomerSerializer.new(customers)
    render json: serialized
  end

  def random
    customer = Customer.order('RANDOM()').first
    serialized = CustomerSerializer.new(customer)
    render json: serialized
  end

  def favorite_merchant
    customer = Customer.find(params[:id])
    fav = Merchant.find((customer.favorite_merchant)[:id])
    serialized = MerchantSerializer.new(fav)
    render json: serialized
  end

  private

  def customer_params
    if params['first_name']
      params['first_name'].gsub(/'/, '%27')
    end
    if params['last_name']
      params['last_name'].gsub(/'/, '%27')
    end
    params.permit(:id, :first_name, :last_name, :updated_at, :created_at)
  end

end
