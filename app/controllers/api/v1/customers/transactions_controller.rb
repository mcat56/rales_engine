class Api::V1::Customers::TransactionsController < ApplicationController

  def index
    customer = Customer.find(params[:customer_id])
    transactions = customer.transactions
    serialized = TransactionSerializer.new(transactions)
    render json: serialized
  end

end
