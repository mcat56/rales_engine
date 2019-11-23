class Api::V1::InvoiceItems::InvoicesController < ApplicationController

  def show
    invoice_item = InvoiceItem.find(params[:id])
    invoice = invoice_item.invoice
    serialized = InvoiceSerializer.new(invoice)
    render json: serialized
  end

end
