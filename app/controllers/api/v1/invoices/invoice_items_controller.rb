class Api::V1::Invoices::InvoiceItemsController < ApplicationController

  def index
    invoice = Invoice.find(params[:invoice_id])
    invoice_items = invoice.invoice_items
    serialized = InvoiceItemSerializer.new(invoice_items)

    render json: serialized
  end
end
