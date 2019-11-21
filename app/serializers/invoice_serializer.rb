class InvoiceSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :status, :merchant_id, :customer_id

  # belongs_to :customer
  # belongs_to :merchant
  # has_many :transactions
  # has_many :invoice_items
  # has_many :items, through: :invoice_items

end
