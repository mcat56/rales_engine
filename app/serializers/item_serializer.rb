class ItemSerializer
  include FastJsonapi::ObjectSerializer

  attributes :name, :description
  attribute :unit_price do |item|
    item.unit_price * 0.01
  end

  belongs_to :merchant
  has_many :invoice_items

end
