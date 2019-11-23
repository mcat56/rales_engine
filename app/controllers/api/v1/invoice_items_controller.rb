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

  def find
    invoice_item = InvoiceItem.where(invoice_item_params).first
    serialized = InvoiceItemSerializer.new(invoice_item)
    render json: serialized
  end

  def find_all
    invoice_items = InvoiceItem.having(invoice_item_params).group(:id).order(:id)
    serialized = InvoiceItemSerializer.new(invoice_items)
    render json: serialized
  end

  def random
    invoice_item = InvoiceItem.order('RANDOM()').first
    serialized = InvoiceItemSerializer.new(invoice_item)
    render json: serialized
  end

  private

  def invoice_item_params
    params.permit(:id, :quantity, :unit_price, :invoice_id, :item_id, :created_at, :updated_at)
  end
end
