require 'rails_helper'
# do sad paths / find / find_all errors
describe 'Items API' do
  it 'sends a list of items' do
    merchant = Merchant.create!(name: 'ToyRUs')
    item_1 = merchant.items.create!(name: 'Teddy Bear', description: 'Fluffy', unit_price: '18.00', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC" )
    item_2 = merchant.items.create!(name: 'Scooter', description: 'Vroom', unit_price: '25.00', created_at: "2014-03-29 14:53:59 UTC", updated_at: "2014-03-29 14:53:59 UTC" )
    item_3 = merchant.items.create!(name: 'Bowl', description: 'Round', unit_price: '10.00', created_at: "2016-03-29 14:53:59 UTC", updated_at: "2016-03-29 14:53:59 UTC" )
    merchant_2 = Merchant.create!(name: 'King Soopers')
    item_4 = merchant.items.create!(name: 'Banana', description: 'Yellow', unit_price: '2.00', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC" )
    item_5 = merchant.items.create!(name: 'Rice', description: 'Brown', unit_price: '3.00', created_at: "2014-03-29 14:53:59 UTC", updated_at: "2014-03-29 14:53:59 UTC" )
    item_6 = merchant.items.create!(name: 'Pumpkin', description: 'Squash', unit_price: '4.00', created_at: "2016-03-29 14:53:59 UTC", updated_at: "2016-03-29 14:53:59 UTC" )

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body)
    expect(items["data"].length).to eq(6)
  end

  it 'can get one item' do
    merchant = Merchant.create(name: 'ToyRUs')
    item_1 = merchant.items.create!(name: 'Teddy Bear', description: 'Fluffy', unit_price: '23.00', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC" )
    item_2 = merchant.items.create!(name: 'Scooter', description: 'Vroom', unit_price: '23.00', created_at: "2014-03-29 14:53:59 UTC", updated_at: "2014-03-29 14:53:59 UTC" )
    item_3 = merchant.items.create!(name: 'Bowl', description: 'Round', unit_price: '23.00', created_at: "2016-03-29 14:53:59 UTC", updated_at: "2016-03-29 14:53:59 UTC" )

    id = item_1.id

    get "/api/v1/items/#{id}"

    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item["data"]["id"].to_i).to eq(id)
  end

  it 'can find a item by any parameter' do
    merchant = Merchant.create(name: 'ToyRUs')
    item_1 = merchant.items.create!(name: 'Teddy Bear', description: 'Fluffy', unit_price: '10.00', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC" )
    item_2 = merchant.items.create!(name: 'Scooter', description: 'Vroom', unit_price: '25.00', created_at: "2014-03-29 14:53:59 UTC", updated_at: "2014-03-29 14:53:59 UTC" )
    item_3 = merchant.items.create!(name: 'Bowl', description: 'Round', unit_price: '8.00', created_at: "2016-03-29 14:53:59 UTC", updated_at: "2016-03-29 14:53:59 UTC" )

    #find by name
    get "/api/v1/items/find?name=#{item_1.name}"

    item_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item_response["data"]["attributes"]["name"]).to eq("#{item_1.name}")

    #find by unit_price

    get "/api/v1/items/find?unit_price=#{item_2.unit_price}"

    expect(response).to be_successful
    item_response = JSON.parse(response.body)
    expect(item_response["data"]["id"]).to eq("#{item_2.id}")

    #find by description

    get "/api/v1/items/find?description=#{item_3.description}"

    expect(response).to be_successful
    item_response = JSON.parse(response.body)
    expect(item_response["data"]["id"]).to eq("#{item_3.id}")

    #find by id
    get "/api/v1/items/find?id=#{item_1.id}"

    item_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item_response["data"]["attributes"]["name"]).to eq("#{item_1.name}")

    #find by merchant_id
    get "/api/v1/items/find?#{merchant.id}"

    expect(response).to be_successful
    item_response = JSON.parse(response.body)
    expect(item_response["data"]["id"]).to eq("#{item_1.id}")

    #find by created_at
    get "/api/v1/items/find?created_at=#{item_2.created_at}"

    item_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item_response["data"]["attributes"]["name"]).to eq("#{item_2.name}")

    #find by updated_at
    get "/api/v1/items/find?updated_at=#{item_3.updated_at}"

    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item["data"]["attributes"]["name"]).to eq("#{item_3.name}")
  end

  it 'can find all items by any parameter' do
    merchant = Merchant.create(name: 'Ikea')
    item_1 = Item.create(name: 'Chair', description: 'wood', unit_price: '45.00', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC", merchant: merchant)
    item_2 = Item.create(name: 'Chair', description: 'wood', unit_price: '45.00', created_at: "2014-03-29 14:53:59 UTC", updated_at: "2014-03-29 14:53:59 UTC", merchant: merchant)
    item_3 = Item.create(name: 'Chair', description: 'wood', unit_price: '45.00', created_at: "2016-03-29 14:53:59 UTC", updated_at: "2016-03-29 14:53:59 UTC", merchant: merchant)

    items = Item.all

    get "/api/v1/items/find_all?name=#{item_1.name}"

    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item["data"].length).to eq(3)
    expect(item["data"].first["id"]).to eq("#{item_1.id}")
    expect(item["data"][1]["id"]).to eq("#{item_2.id}")
    expect(item["data"][2]["id"]).to eq("#{item_3.id}")

    get "/api/v1/items/find_all?id=#{item_1.id}"

    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item["data"]).to be_a(Array)
    expect(item["data"].first["attributes"]["name"]).to eq("#{item_1.name}")

    get "/api/v1/items/find_all?created_at=#{item_1.created_at}"

    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item["data"]).to be_a(Array)
    expect(item["data"].first["attributes"]["name"]).to eq("#{item_1.name}")

    get "/api/v1/items/find_all?updated_at=#{item_1.updated_at}"

    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item["data"]).to be_a(Array)
    expect(item["data"].first["attributes"]["name"]).to eq("#{item_1.name}")

  end

  it 'can select a random item' do
    merchant = Merchant.create(name: 'ToyRUs')
    item_1 = merchant.items.create(name: 'Teddy Bear', description: 'Fluffy', unit_price: '15.00', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC" )
    item_2 = merchant.items.create(name: 'Scooter', description: 'Vroom', unit_price: '23.00', created_at: "2014-03-29 14:53:59 UTC", updated_at: "2014-03-29 14:53:59 UTC" )
    item_3 = merchant.items.create(name: 'Bowl', description: 'Round', unit_price: '10.00', created_at: "2016-03-29 14:53:59 UTC", updated_at: "2016-03-29 14:53:59 UTC" )
    merchant_2 = Merchant.create(name: 'King Soopers')
    item_4 = merchant.items.create(name: 'Banana', description: 'Yellow', unit_price: '2.00', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC" )
    item_5 = merchant.items.create(name: 'Rice', description: 'Brown', unit_price: '3.00', created_at: "2014-03-29 14:53:59 UTC", updated_at: "2014-03-29 14:53:59 UTC" )
    item_6 = merchant.items.create(name: 'Pumpkin', description: 'Squash', unit_price: '4.00', created_at: "2016-03-29 14:53:59 UTC", updated_at: "2016-03-29 14:53:59 UTC" )

    get '/api/v1/items/random'

    expect(response).to be_successful
    items = Item.all.pluck(:id)
    item = JSON.parse(response.body)
    expect(items).to include(item["data"]["id"].to_i)
  end

  it 'can get an items invoice_items' do
    merchant = Merchant.create(name: 'ToysRUs')
    item = merchant.items.create(name: 'Teddy Bear', description: 'Fluffy', unit_price: '1500', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC" )

    customer = create(:customer)
    invoice_1 = merchant.invoices.create(customer: customer, status: 'shipped')
    invoice_2 = merchant.invoices.create(customer: customer, status: 'shipped')
    invoice_3 = merchant.invoices.create(customer: customer, status: 'shipped')
    invoice_4 = merchant.invoices.create(customer: customer, status: 'shipped')
    invoice_item_1 = invoice_1.invoice_items.create(item: item, quantity: 1, unit_price: '12.00', created_at: "2012-03-28 14:53:59 UTC", updated_at: "2012-03-28 14:53:59 UTC" )
    invoice_item_2 = invoice_2.invoice_items.create(item: item, quantity: 3, unit_price: '12.00', created_at: "2012-03-28 14:53:59 UTC", updated_at: "2012-03-28 14:53:59 UTC" )
    invoice_item_3 = invoice_3.invoice_items.create(item: item, quantity: 2, unit_price: '12.00', created_at: "2012-03-28 14:53:59 UTC", updated_at: "2012-03-28 14:53:59 UTC" )
    invoice_item_4 = invoice_4.invoice_items.create(item: item, quantity: 5, unit_price: '12.00', created_at: "2012-03-28 14:53:59 UTC", updated_at: "2012-03-28 14:53:59 UTC" )


    get "/api/v1/items/#{item.id}/invoice_items"

    invoices = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoices["data"].length).to eq(4)
    expect(invoices["data"].first["attributes"]["quantity"]).to eq(1)
    expect(invoices["data"].first["attributes"]["unit_price"]).to eq('12.00')
  end

  it 'can get an items merchant' do
    merchant = Merchant.create(name: 'ToysRUs')
    item = merchant.items.create(name: 'Teddy Bear', description: 'Fluffy', unit_price: '1500', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC" )

    get "/api/v1/items/#{item.id}/merchant"

    expect(response).to be_successful
    merchant_response = JSON.parse(response.body)
    expect(merchant_response["data"]["id"]).to eq("#{merchant.id}")
  end

  it 'can get top items by total revenue' do
    customer = create(:customer)
    merchant_1 = create(:merchant)
    item_1 = merchant_1.items.create(name: 'Teddy Bear', description: 'Fluffy', unit_price: '12.00')

    merchant_2 = create(:merchant)
    item_2 = merchant_2.items.create(name: 'Barbie', description: 'Basic', unit_price: '20.00')

    merchant_3 = create(:merchant)
    item_3 = merchant_3.items.create(name: 'Scooter', description: 'Vroom', unit_price: '35.00')

    invoice_1 = customer.invoices.create(merchant: merchant_1, status: 'shipped')
    invoice_item_1 = invoice_1.invoice_items.create(item: item_1, quantity: 4, unit_price: '12.00')

    invoice_2 = customer.invoices.create(merchant: merchant_2, status: 'shipped')
    invoice_item_2 = invoice_2.invoice_items.create(item: item_2, quantity: 3, unit_price: '20.00')

    invoice_3 = customer.invoices.create(merchant: merchant_3, status: 'shipped')
    invoice_item_3 = invoice_3.invoice_items.create(item: item_3, quantity: 1, unit_price: '35.00')

    transaction_1 = invoice_1.transactions.create(credit_card_number: '4654405418249632', result: 'success')
    transaction_2 = invoice_2.transactions.create(credit_card_number: '4515551623735607', result: 'failure')
    transaction_3 = invoice_3.transactions.create(credit_card_number: '4515551623735607', result: 'success')

    get "/api/v1/items/most_revenue?quantity=2"
    top_items = JSON.parse(response.body)
    expect(response).to be_successful
    expect(top_items["data"].first["attributes"]["name"]).to eq("#{item_1.name}")
    expect(top_items["data"][1]["attributes"]["name"]).to eq("#{item_3.name}")
    expect(top_items["data"].length).to eq(2)
  end

  it 'can get the date with the most sales for an item' do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)
    item_1 = merchant_1.items.create(name: 'Teddy Bear', description: 'Fluffy', unit_price: '12.00')

    invoice_1 = customer_1.invoices.create(merchant: merchant_1, status: 'shipped', created_at: "2012-03-28 16:53:59 UTC", updated_at: "2012-03-28 16:53:59 UTC" )
    invoice_item_1 = invoice_1.invoice_items.create(item: item_1, quantity: 2, unit_price: '12.00', created_at: "2012-03-28 14:53:59 UTC", updated_at: "2012-03-28 14:53:59 UTC" )

    invoice_2 = customer_1.invoices.create(merchant: merchant_1, status: 'shipped', created_at: "2012-03-28 12:53:59 UTC", updated_at: "2012-03-28 12:53:59 UTC" )
    invoice_item_2 = invoice_2.invoice_items.create(item: item_1, quantity: 2, unit_price: '12.00', created_at: "2012-03-28 12:53:59 UTC", updated_at: "2012-03-28 12:53:59 UTC" )

    invoice_3 = customer_1.invoices.create(merchant: merchant_1, status: 'shipped', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC" )
    invoice_item_3 = invoice_3.invoice_items.create(item: item_1, quantity: 1, unit_price: '12.00', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC" )

    invoice_4 = customer_1.invoices.create(merchant: merchant_1, status: 'shipped', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-28 14:53:59 UTC" )
    invoice_item_4 = invoice_4.invoice_items.create(item: item_1, quantity: 1, unit_price: '12.00', created_at: "2012-03-28 14:53:59 UTC", updated_at: "2012-03-28 14:53:59 UTC" )

    invoice_5 = customer_1.invoices.create(merchant: merchant_1, status: 'shipped', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-28 14:53:59 UTC" )
    invoice_item_5 = invoice_5.invoice_items.create(item: item_1, quantity: 4, unit_price: '12.00', created_at: "2012-03-28 14:53:59 UTC", updated_at: "2012-03-28 14:53:59 UTC" )

    invoice_6 = customer_1.invoices.create(merchant: merchant_1, status: 'shipped', created_at: "2012-03-30 14:53:59 UTC", updated_at: "2012-03-28 14:53:59 UTC" )
    invoice_item_6 = invoice_6.invoice_items.create(item: item_1, quantity: 5, unit_price: '12.00', created_at: "2012-03-28 14:53:59 UTC", updated_at: "2012-03-28 14:53:59 UTC" )

    invoice_7 = customer_1.invoices.create(merchant: merchant_1, status: 'shipped', created_at: "2012-03-30 14:53:59 UTC", updated_at: "2012-03-28 14:53:59 UTC" )
    invoice_item_7 = invoice_7.invoice_items.create(item: item_1, quantity: 1, unit_price: '12.00', created_at: "2012-03-28 14:53:59 UTC", updated_at: "2012-03-28 14:53:59 UTC" )

    transaction_1 = invoice_1.transactions.create(credit_card_number: '4654405418249632', result: 'success', created_at: "2012-03-28 14:53:59 UTC", updated_at: "2012-03-28 14:53:59 UTC" )
    transaction_2 = invoice_2.transactions.create(credit_card_number: '4515551623735607', result: 'success', created_at: "2012-03-28 12:53:59 UTC", updated_at: "2012-03-28 12:53:59 UTC" )
    transaction_3 = invoice_3.transactions.create(credit_card_number: '4515551623735607', result: 'failure', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC" )
    transaction_4 = invoice_4.transactions.create(credit_card_number: '4654405418249632', result: 'failure', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC" )
    transaction_5 = invoice_5.transactions.create(credit_card_number: '4654405418249632', result: 'success', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC" )
    transaction_6 = invoice_6.transactions.create(credit_card_number: '4654405418249632', result: 'success', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC" )
    transaction_7 = invoice_7.transactions.create(credit_card_number: '4654405418249632', result: 'failure', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC" )

    get "/api/v1/items/#{item_1.id}/best_day"

    expect(response).to be_successful
    best_day = JSON.parse(response.body)

    expect(best_day["data"]["attributes"]["best_day"]).to eq('2012-03-30')
  end

end
