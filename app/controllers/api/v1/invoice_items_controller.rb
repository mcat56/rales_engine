class Api::V1::InvoiceItemsController < ApplicationController

  def index
    invoice_items = InvoiceItem.all
    serialized = InvoiceItemSerializer.new(invoice_items)
    render json: serialized
  end

  def show
    invoice_item = InvoiceItem.find(params[:id])
    serialized = InvoiceItemSerializer.new(invoice_item)
    render json: serialized
  end

end
