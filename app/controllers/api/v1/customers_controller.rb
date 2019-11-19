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
    customer = Customer.where("#{params.keys.first} = '#{params.values.first}'")
    serialized = CustomerSerializer.new(customer)
    render json: serialized
  end

  def find_all
    customers = Customer.having("#{params.keys.first} = '#{params.values.first}'").group(:id)
    serialized = CustomerSerializer.new(customers)
    render json: serialized
  end

  def random
    customer = Customer.order('RANDOM()').first
    serialized = CustomerSerializer.new(customer)
    render json: serialized
  end
end
