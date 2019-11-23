class InvoiceItemSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :quantity, :invoice_id, :item_id

  attribute :unit_price do |invoice_item|
    '%.2f' % (invoice_item.unit_price)
  end



end
