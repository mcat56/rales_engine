class InvoiceItemSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :quantity

  attribute :unit_price do |invoice_item|
    invoice_item.unit_price * 0.01
  end



end
