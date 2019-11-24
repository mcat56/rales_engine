class Api::V1::Invoices::SearchController < ApplicationController

  def show
    invoice = Invoice.where(invoice_params).first
    serialized = InvoiceSerializer.new(invoice)
    render json: serialized
  end

  def index
    invoices = Invoice.having(invoice_params).group(:id).order(:id)
    serialized = InvoiceSerializer.new(invoices)
    render json: serialized
  end

  def random
    invoice = Invoice.order('RANDOM()').first
    serialized = InvoiceSerializer.new(invoice)
    render json: serialized
  end

  private

  def invoice_params
    params.permit(:id, :status, :merchant_id, :customer_id, :updated_at, :created_at)
  end

end
