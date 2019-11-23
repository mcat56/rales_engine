FactoryBot.define do
  factory :invoice_item, class: InvoiceItem do
    item
    invoice
    unit_price { (Faker::Commerce.price) }
    quantity { Faker::Number.between(from: 1, to: 20) }
    created_at { "2012-03-27 14:53:59 UTC" }
    updated_at { "2012-03-27 14:53:59 UTC" }
  end
end
