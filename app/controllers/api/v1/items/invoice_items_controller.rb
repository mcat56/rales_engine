class Api::V1::Items::InvoiceItemsController < ApplicationController

  def index
    item = Item.find(params[:item_id])
    invoice_items = item.invoice_items
    serialized = InvoiceItemSerializer.new(invoice_items)
    render json: serialized
  end

end
