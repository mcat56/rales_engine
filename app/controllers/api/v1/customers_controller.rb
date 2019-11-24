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

end
