class Api::V1::Transactions::InvoicesController < ApplicationController

  def show
    transaction = Transaction.find(params[:id])
    invoice = transaction.invoice
    serialized = InvoiceSerializer.new(invoice)
    render json: serialized
  end


end
