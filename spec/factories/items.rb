FactoryBot.define do
  factory :item, class: Item do
    name { Faker::Commerce.product_name}
    unit_price { (Faker::Commerce.price) * 100 }
  end
end
