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

  def find
    transaction = Transaction.where(transaction_params).first
    serialized = TransactionSerializer.new(transaction)
    render json: serialized
  end

  def find_all
    transactions = Transaction.having(transaction_params).group(:id).order(:id)
    serialized = TransactionSerializer.new(transactions)
    render json: serialized
  end

  def random
    transaction = Transaction.order('RANDOM()').first
    serialized = TransactionSerializer.new(transaction)
    render json: serialized
  end

  private

  def transaction_params
    params.permit(:id, :result, :credit_card_number, :invoice_id, :created_at, :updated_at)
  end


end
