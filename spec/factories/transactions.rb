FactoryBot.define do
  factory :transaction, class: Transaction do
    invoice
    credit_card_number { (Faker::Business.credit_card_number) }
    result { 'success' }
    created_at { "2012-03-27 14:53:59 UTC" }
    updated_at { "2012-03-27 14:53:59 UTC" }
  end
end
