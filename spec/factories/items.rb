FactoryBot.define do
  factory :item, class: Item do
    merchant
    name { Faker::Commerce.product_name}
    description { 'totally awesome' }
    unit_price { (Faker::Commerce.price) }
  end
end
