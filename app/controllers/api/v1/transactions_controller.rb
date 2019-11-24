class Api::V1::TransactionsController < ApplicationController

  def index
    transactions = Transaction.all
    serialized = TransactionSerializer.new(transactions)
    render json: serialized
  end

  def show
    transaction = Transaction.find(params[:id])
    serialized = TransactionSerializer.new(transaction)
    render json: serialized
  end


end
