class Api::V1::InvoiceItems::ItemsController < ApplicationController

  def show
    invoice_item = InvoiceItem.find(params[:id])
    item = invoice_item.item
    serialized = ItemSerializer.new(item)
    render json: serialized
  end

end
