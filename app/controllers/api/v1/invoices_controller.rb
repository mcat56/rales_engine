class Api::V1::InvoicesController < ApplicationController


  def index
    invoices = Invoice.all
    serialized = InvoiceSerializer.new(invoices)
    render json: serialized
  end


  def show
    invoice = Invoice.find(params[:id])
    serialized = InvoiceSerializer.new(invoice)
    render json: serialized
  end

end
