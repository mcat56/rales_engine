class Api::V1::CustomersController < ApplicationController

  def index
    customers = Customer.all
    serialized = CustomerSerializer.new(customers)
    render json: serialized
  end

  def show
    customer = Customer.find(params[:id])
    serialized = CustomerSerializer.new(customer)
    render json: serialized
  end

  def find

    customer = Customer.where("#{params.keys.first} = '#{params.values.first.gsub(/'/, '%')}'")
    serialized = CustomerSerializer.new(customer)
    render json: serialized
  end

  def find_all
    customers = Customer.having("#{params.keys.first} = '#{params.values.first.gsub(/'/, '%')}'").group(:id)
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

  def customers_params
    params.require(:customer).permit(Customer.column_names)
  end
end
