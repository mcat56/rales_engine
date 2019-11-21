require 'rails_helper'
# do sad paths / find / find_all errors
describe 'Items API' do
  it 'sends a list of merchants' do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body)
    expect(merchants["data"].length).to eq(3)
  end

  it 'can get one merchant' do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"]["id"].to_i).to eq(id)
  end

  it 'can find a merchant by any parameter' do
    merchant_1 = Merchant.create(name: 'ToysRUs', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC")
    merchant_2 = Merchant.create(name: 'REI', created_at: "2014-03-29 14:53:59 UTC", updated_at: "2014-03-29 14:53:59 UTC")
    merchant_3 = Merchant.create(name: 'Barnes&Noble', created_at: "2016-03-29 14:53:59 UTC", updated_at: "2016-03-29 14:53:59 UTC")

    #find by name
    get "/api/v1/merchants/find?name=#{merchant_1.name}"

    merchant_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant_response["data"]["attributes"]["name"]).to eq("#{merchant_1.name}")

    #find by id
    get "/api/v1/merchants/find?id=#{merchant_1.id}"

    merchant_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant_response["data"]["attributes"]["name"]).to eq("#{merchant_1.name}")

    #find by created_at
    get "/api/v1/merchants/find?created_at=#{merchant_2.created_at}"

    merchant_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant_response["data"]["attributes"]["name"]).to eq("#{merchant_2.name}")

    #find by updated_at
    get "/api/v1/merchants/find?updated_at=#{merchant_3.updated_at}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"]["attributes"]["name"]).to eq("#{merchant_3.name}")
  end

  it 'can find all items by any parameter' do
    merchant_1 = Merchant.create(name: 'Thai Tanic', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC")
    merchant_2 = Merchant.create(name: 'Thai Tanic', created_at: "2014-03-29 14:53:59 UTC", updated_at: "2014-03-29 14:53:59 UTC")
    merchant_3 = Merchant.create(name: 'Thai Tanic', created_at: "2016-03-29 14:53:59 UTC", updated_at: "2016-03-29 14:53:59 UTC")

    merchants = Merchant.all

    get "/api/v1/merchants/find_all?name=#{merchant_1.name}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"].length).to eq(3)
    expect(merchant["data"].first["id"]).to eq("#{merchant_1.id}")
    expect(merchant["data"][1]["id"]).to eq("#{merchant_2.id}")
    expect(merchant["data"][2]["id"]).to eq("#{merchant_3.id}")

    get "/api/v1/merchants/find_all?id=#{merchant_1.id}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"]).to be_a(Array)
    expect(merchant["data"].first["attributes"]["name"]).to eq("#{merchant_1.name}")

    get "/api/v1/merchants/find_all?created_at=#{merchant_1.created_at}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"]).to be_a(Array)
    expect(merchant["data"].first["attributes"]["name"]).to eq("#{merchant_1.name}")

    get "/api/v1/merchants/find_all?updated_at=#{merchant_1.updated_at}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"]).to be_a(Array)
    expect(merchant["data"].first["attributes"]["name"]).to eq("#{merchant_1.name}")

  end

  it 'can select a random merchant' do
    merchant = Merchant.create(name: 'Thai Tanic')

    get '/api/v1/merchants/random'

    expect(response).to be_successful

    merchant = JSON.parse(response.body)
    expect(merchant["data"]["attributes"]["name"]).to eq('Thai Tanic')
  end

  it 'can get a merchants invoices' do
    merchant = create(:merchant)
    customer = create(:customer)
    invoice_1 = merchant.invoices.create(customer: customer, status: 'shipped')
    invoice_2 = merchant.invoices.create(customer: customer, status: 'shipped')
    invoice_3 = merchant.invoices.create(customer: customer, status: 'shipped')
    invoice_4 = merchant.invoices.create(customer: customer, status: 'shipped')

    get "/api/v1/merchants/#{merchant.id}/invoices"

    invoices = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoices["data"].length).to eq(4)
  end

  it 'can get a merchants items' do
    merchant = create(:merchant)
    item_1 = merchant.items.create(name: 'Teddy Bear', description: 'Fluffy', unit_price: 1200)
    item_2 = merchant.items.create(name: 'Barbie', description: 'Basic', unit_price: 2000)
    item_3 = merchant.items.create(name: 'Scooter', description: 'Vroom', unit_price: 3500)

    get "/api/v1/merchants/#{merchant.id}/items"

    items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(items["data"].length).to eq(3)
    expect(items["data"].first["attributes"]["name"]).to eq('Teddy Bear')
    expect(items["data"].first["attributes"]["description"]).to eq('Fluffy')
    expect(items["data"].first["attributes"]["unit_price"]).to eq(12.00)
  end

  it 'can get top merchants ranked by total revenue' do
    customer = create(:customer)
    merchant_1 = create(:merchant)
    item_1 = merchant_1.items.create(name: 'Teddy Bear', description: 'Fluffy', unit_price: 1200)

    merchant_2 = create(:merchant)
    item_2 = merchant_2.items.create(name: 'Barbie', description: 'Basic', unit_price: 2000)

    merchant_3 = create(:merchant)
    item_3 = merchant_3.items.create(name: 'Scooter', description: 'Vroom', unit_price: 3500)

    invoice_1 = customer.invoices.create(merchant: merchant_1, status: 'shipped')
    invoice_item_1 = invoice_1.invoice_items.create(item: item_1, quantity: 4, unit_price: 1200)

    invoice_2 = customer.invoices.create(merchant: merchant_2, status: 'shipped')
    invoice_item_2 = invoice_2.invoice_items.create(item: item_2, quantity: 3, unit_price: 2000)

    invoice_3 = customer.invoices.create(merchant: merchant_3, status: 'shipped')
    invoice_item_3 = invoice_3.invoice_items.create(item: item_3, quantity: 1, unit_price: 3500)

    transaction_1 = invoice_1.transactions.create(credit_card_number: '4654405418249632', result: 'success')
    transaction_2 = invoice_2.transactions.create(credit_card_number: '4515551623735607', result: 'success')
    transaction_3 = invoice_3.transactions.create(credit_card_number: '4515551623735607', result: 'success')

    get "/api/v1/merchants/most_revenue?quantity=2"
    top_merchants = JSON.parse(response.body)
    expect(response).to be_successful
    expect(top_merchants["data"].first["attributes"]["name"]).to eq("#{merchant_2.name}")
    expect(top_merchants["data"][1]["attributes"]["name"]).to eq("#{merchant_1.name}")
    expect(top_merchants["data"].length).to eq(2)
  end

  it 'can get the total revenue for merchants for one day' do
    customer_1 = create(:customer)
    customer_2 = create(:customer)
    customer_3 = create(:customer)
    merchant_1 = create(:merchant)
    item_1 = merchant_1.items.create(name: 'Teddy Bear', description: 'Fluffy', unit_price: 1200)

    merchant_2 = create(:merchant)
    item_2 = merchant_2.items.create(name: 'Barbie', description: 'Basic', unit_price: 2000)

    merchant_3 = create(:merchant)
    item_3 = merchant_3.items.create(name: 'Scooter', description: 'Vroom', unit_price: 3500)

    invoice_1 = customer_1.invoices.create(merchant: merchant_1, status: 'shipped', created_at: "2012-03-28 14:53:59 UTC", updated_at: "2012-03-28 14:53:59 UTC" )
    invoice_item_1 = invoice_1.invoice_items.create(item: item_1, quantity: 4, unit_price: 1200, created_at: "2012-03-28 14:53:59 UTC", updated_at: "2012-03-28 14:53:59 UTC" )

    invoice_2 = customer_2.invoices.create(merchant: merchant_2, status: 'shipped', created_at: "2012-03-28 12:53:59 UTC", updated_at: "2012-03-28 12:53:59 UTC" )
    invoice_item_2 = invoice_2.invoice_items.create(item: item_2, quantity: 3, unit_price: 2000, created_at: "2012-03-28 12:53:59 UTC", updated_at: "2012-03-28 12:53:59 UTC" )

    invoice_3 = customer_3.invoices.create(merchant: merchant_3, status: 'shipped', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC" )
    invoice_item_3 = invoice_3.invoice_items.create(item: item_3, quantity: 1, unit_price: 3500, created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC" )
    transaction_1 = invoice_1.transactions.create(credit_card_number: '4654405418249632', result: 'success', created_at: "2012-03-28 14:53:59 UTC", updated_at: "2012-03-28 14:53:59 UTC" )
    transaction_2 = invoice_2.transactions.create(credit_card_number: '4515551623735607', result: 'failure', created_at: "2012-03-28 12:53:59 UTC", updated_at: "2012-03-28 12:53:59 UTC" )
    transaction_3 = invoice_3.transactions.create(credit_card_number: '4515551623735607', result: 'success', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC" )


    get '/api/v1/merchants/revenue?date=2012-03-28'

    expect(response).to be_successful
    revenue = JSON.parse(response.body)
    expect(revenue["data"]["attributes"]["total_revenue"]).to eq('48.00')
  end

  it 'can get a merchants favorite customer' do
    customer_1 = create(:customer)
    customer_2 = create(:customer)
    customer_3 = create(:customer)
    merchant_1 = create(:merchant)
    item_1 = merchant_1.items.create(name: 'Teddy Bear', description: 'Fluffy', unit_price: 1200)

    invoice_1 = customer_1.invoices.create(merchant: merchant_1, status: 'shipped', created_at: "2012-03-28 14:53:59 UTC", updated_at: "2012-03-28 14:53:59 UTC" )
    invoice_item_1 = invoice_1.invoice_items.create(item: item_1, quantity: 1, unit_price: 1200, created_at: "2012-03-28 14:53:59 UTC", updated_at: "2012-03-28 14:53:59 UTC" )

    invoice_2 = customer_2.invoices.create(merchant: merchant_1, status: 'shipped', created_at: "2012-03-28 12:53:59 UTC", updated_at: "2012-03-28 12:53:59 UTC" )
    invoice_item_2 = invoice_2.invoice_items.create(item: item_1, quantity: 3, unit_price: 1200, created_at: "2012-03-28 12:53:59 UTC", updated_at: "2012-03-28 12:53:59 UTC" )

    invoice_3 = customer_3.invoices.create(merchant: merchant_1, status: 'shipped', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC" )
    invoice_item_3 = invoice_3.invoice_items.create(item: item_1, quantity: 4, unit_price: 1200, created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC" )

    invoice_4 = customer_1.invoices.create(merchant: merchant_1, status: 'shipped', created_at: "2012-03-28 14:53:59 UTC", updated_at: "2012-03-28 14:53:59 UTC" )
    invoice_item_4 = invoice_4.invoice_items.create(item: item_1, quantity: 1, unit_price: 1200, created_at: "2012-03-28 14:53:59 UTC", updated_at: "2012-03-28 14:53:59 UTC" )

    invoice_5 = customer_1.invoices.create(merchant: merchant_1, status: 'shipped', created_at: "2012-03-28 14:53:59 UTC", updated_at: "2012-03-28 14:53:59 UTC" )
    invoice_item_5 = invoice_5.invoice_items.create(item: item_1, quantity: 1, unit_price: 1200, created_at: "2012-03-28 14:53:59 UTC", updated_at: "2012-03-28 14:53:59 UTC" )

    invoice_6 = customer_2.invoices.create(merchant: merchant_1, status: 'shipped', created_at: "2012-03-28 14:53:59 UTC", updated_at: "2012-03-28 14:53:59 UTC" )
    invoice_item_6 = invoice_6.invoice_items.create(item: item_1, quantity: 1, unit_price: 1200, created_at: "2012-03-28 14:53:59 UTC", updated_at: "2012-03-28 14:53:59 UTC" )

    invoice_7 = customer_2.invoices.create(merchant: merchant_1, status: 'shipped', created_at: "2012-03-28 14:53:59 UTC", updated_at: "2012-03-28 14:53:59 UTC" )
    invoice_item_7 = invoice_7.invoice_items.create(item: item_1, quantity: 1, unit_price: 1200, created_at: "2012-03-28 14:53:59 UTC", updated_at: "2012-03-28 14:53:59 UTC" )

    transaction_1 = invoice_1.transactions.create(credit_card_number: '4654405418249632', result: 'success', created_at: "2012-03-28 14:53:59 UTC", updated_at: "2012-03-28 14:53:59 UTC" )
    transaction_2 = invoice_2.transactions.create(credit_card_number: '4515551623735607', result: 'success', created_at: "2012-03-28 12:53:59 UTC", updated_at: "2012-03-28 12:53:59 UTC" )
    transaction_3 = invoice_3.transactions.create(credit_card_number: '4515551623735607', result: 'success', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC" )
    transaction_4 = invoice_4.transactions.create(credit_card_number: '4654405418249632', result: 'success', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC" )
    transaction_5 = invoice_4.transactions.create(credit_card_number: '4654405418249632', result: 'success', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC" )
    transaction_6 = invoice_4.transactions.create(credit_card_number: '4654405418249632', result: 'success', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC" )
    transaction_7 = invoice_4.transactions.create(credit_card_number: '4654405418249632', result: 'failure', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC" )

    get "/api/v1/merchants/#{merchant_1.id}/favorite_customer"

    expect(response).to be_successful
    customer = JSON.parse(response.body)
    expect(customer["data"]["attributes"]["first_name"]).to eq("#{customer_1.first_name}")
  end



end
