require 'rails_helper'
# do sad paths / find / find_all errors
describe 'InvoiceItems API' do
  it 'gets a list of invoice_items' do
    create_list(:invoice_item, 3)

    get '/api/v1/invoice_items'

    expect(response).to be_successful

    invoice_items = JSON.parse(response.body)
    expect(invoice_items["data"].length).to eq(3)
  end

  it 'can get show a invoice_item' do
    id = create(:invoice_item).id

    get "/api/v1/invoice_items/#{id}"

    invoice_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_item["data"]["id"].to_i).to eq(id)
  end

  it 'can find a invoice_item by any parameter' do
    merchant = create(:merchant)
    customer = create(:customer)
    invoice = merchant.invoices.create(customer: customer, status: 'shipped', created_at: "2012-03-22 14:53:59 UTC", updated_at: "2012-03-22 14:53:59 UTC")

    item_1 = merchant.items.create(name: 'Teddy Bear', description: 'Fluffy', unit_price: '10.00')
    item_2 = merchant.items.create(name: 'Barbie', description: 'Basic', unit_price: '15.00')
    item_3 = merchant.items.create(name: 'Scooter', description: 'Vroom', unit_price: '20.00')

    invoice_1 = customer.invoices.create(merchant: merchant, status: 'shipped')
    invoice_2 = customer.invoices.create(merchant: merchant, status: 'shipped')
    invoice_3 = customer.invoices.create(merchant: merchant, status: 'shipped')
    invoice_item_1 = invoice_1.invoice_items.create(item: item_1, quantity: 4, unit_price: '10.00', created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC" )
    invoice_item_2 = invoice_2.invoice_items.create(item: item_2, quantity: 2, unit_price: '15.00', created_at: "2012-03-23 14:53:59 UTC", updated_at: "2012-03-23 14:53:59 UTC" )
    invoice_item_3 = invoice_3.invoice_items.create(item: item_3, quantity: 1, unit_price: '20.00', created_at: "2012-03-25 14:53:59 UTC", updated_at: "2012-03-25 14:53:59 UTC" )

    #find by id
    get "/api/v1/invoice_items/find?id=#{invoice_item_1.id}"

    invoice_item_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_item_response["data"]["attributes"]["id"]).to eq(invoice_item_1.id)

    #find by unit_price
    get "/api/v1/invoice_items/find?unit_price=#{invoice_item_2.unit_price}"

    invoice_item_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_item_response["data"]["attributes"]["id"]).to eq(invoice_item_2.id)

    #find by quantity
    get "/api/v1/invoice_items/find?quantity=#{invoice_item_3.quantity}"

    invoice_item_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_item_response["data"]["attributes"]["id"]).to eq(invoice_item_3.id)

    #find by item
    get "/api/v1/invoice_items/find?item_id=#{invoice_item_1.item.id}"

    invoice_item_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_item_response["data"]["attributes"]["id"]).to eq(invoice_item_1.id)

    #find by invoice
    get "/api/v1/invoice_items/find?invoice_id=#{invoice_item_3.invoice.id}"

    invoice_item_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_item_response["data"]["attributes"]["id"]).to eq(invoice_item_3.id)

    #find by created_at
    get "/api/v1/invoice_items/find?created_at=#{invoice_item_1.created_at}"

    invoice_item_response = JSON.parse(response.body)
    expect(response).to be_successful
    expect(invoice_item_response["data"]["attributes"]["id"]).to eq(invoice_item_1.id)

    #find by updated_at
    get "/api/v1/invoice_items/find?updated_at=#{invoice_item_2.updated_at}"

    invoice_item_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_item_response["data"]["attributes"]["id"]).to eq(invoice_item_2.id)
  end

  it 'can find all invoice_items by any parameter' do
    merchant = create(:merchant)
    customer = create(:customer)
    invoice_1 = merchant.invoices.create(customer: customer, status: 'shipped', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC")
    invoice_2 = merchant.invoices.create(customer: customer, status: 'packaged', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC")
    invoice_3 = merchant.invoices.create(customer: customer, status: 'cancelled', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC")
    item_1 = merchant.items.create(name: 'Teddy Bear', description: 'Fluffy', unit_price: '10.00')
    item_2 = merchant.items.create(name: 'Barbie', description: 'Basic', unit_price: '15.00')
    item_3 = merchant.items.create(name: 'Scooter', description: 'Vroom', unit_price: '20.00')

    invoice_item_1 = invoice_1.invoice_items.create(item: item_1, quantity: 4, unit_price: '10.00', created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC" )
    invoice_item_2 = invoice_2.invoice_items.create(item: item_2, quantity: 2, unit_price: '15.00', created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC" )
    invoice_item_3 = invoice_3.invoice_items.create(item: item_3, quantity: 1, unit_price: '20.00', created_at: "2012-03-28 14:53:59 UTC", updated_at: "2012-03-28 14:53:59 UTC" )
    invoice_item_4 = invoice_1.invoice_items.create(item: item_1, quantity: 4, unit_price: '10.00', created_at: "2012-03-28 14:53:59 UTC", updated_at: "2012-03-28 14:53:59 UTC" )
    invoice_item_5 = invoice_2.invoice_items.create(item: item_2, quantity: 2, unit_price: '15.00', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC" )
    invoice_item_6 = invoice_3.invoice_items.create(item: item_3, quantity: 1, unit_price: '20.00', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC" )


    get "/api/v1/invoice_items/find_all?id=#{invoice_item_1.id}"

    invoice_item_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_item_response["data"]).to be_a(Array)
    expect(invoice_item_response["data"].first["id"]).to eq("#{invoice_item_1.id}")

   #find all by unit price
    get "/api/v1/invoice_items/find_all?unit_price=#{invoice_item_1.unit_price}"

    invoice_item_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_item_response["data"].length).to eq(2)
    expect(invoice_item_response["data"].first["id"]).to eq("#{invoice_item_1.id}")
    expect(invoice_item_response["data"][1]["id"]).to eq("#{invoice_item_4.id}")

   #find all by quantity
    get "/api/v1/invoice_items/find_all?quantity=#{invoice_item_2.quantity}"

    invoice_item_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_item_response["data"].length).to eq(2)
    expect(invoice_item_response["data"].first["id"]).to eq("#{invoice_item_2.id}")
    expect(invoice_item_response["data"][1]["id"]).to eq("#{invoice_item_5.id}")

    #find all by item id
    get "/api/v1/invoice_items/find_all?item_id=#{invoice_item_2.item.id}"

    invoice_item_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_item_response["data"].length).to eq(2)
    expect(invoice_item_response["data"].first["id"]).to eq("#{invoice_item_2.id}")
    expect(invoice_item_response["data"][1]["id"]).to eq("#{invoice_item_5.id}")

    #find all by invoice id
    get "/api/v1/invoice_items/find_all?invoice_id=#{invoice_item_3.invoice.id}"

    invoice_item_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_item_response["data"].length).to eq(2)
    expect(invoice_item_response["data"].first["id"]).to eq("#{invoice_item_3.id}")
    expect(invoice_item_response["data"][1]["id"]).to eq("#{invoice_item_6.id}")

    #find all by created_at
    get "/api/v1/invoice_items/find_all?created_at=#{invoice_item_3.created_at}"

    invoice_item_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_item_response["data"].length).to eq(2)
    expect(invoice_item_response["data"].first["id"]).to eq("#{invoice_item_3.id}")
    expect(invoice_item_response["data"][1]["id"]).to eq("#{invoice_item_4.id}")

    #find all by updated_at
    get "/api/v1/invoice_items/find_all?updated_at=#{invoice_item_5.updated_at}"

    invoice_item_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_item_response["data"].length).to eq(2)
    expect(invoice_item_response["data"].first["id"]).to eq("#{invoice_item_5.id}")
    expect(invoice_item_response["data"][1]["id"]).to eq("#{invoice_item_6.id}")
  end

  it 'can select a random invoice_item' do
    merchant = create(:merchant)
    customer = create(:customer)
    invoice_1 = merchant.invoices.create(customer: customer, status: 'shipped', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC")
    invoice_2 = merchant.invoices.create(customer: customer, status: 'packaged', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC")
    invoice_3 = merchant.invoices.create(customer: customer, status: 'cancelled', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC")
    item_1 = merchant.items.create(name: 'Teddy Bear', description: 'Fluffy', unit_price: '10.00')
    item_2 = merchant.items.create(name: 'Barbie', description: 'Basic', unit_price: '15.00')
    item_3 = merchant.items.create(name: 'Scooter', description: 'Vroom', unit_price: '20.00')

    invoice_item_1 = invoice_1.invoice_items.create(item: item_1, quantity: 4, unit_price: '10.00', created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC" )
    invoice_item_2 = invoice_2.invoice_items.create(item: item_2, quantity: 2, unit_price: '15.00', created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC" )
    invoice_item_3 = invoice_3.invoice_items.create(item: item_3, quantity: 1, unit_price: '20.00', created_at: "2012-03-28 14:53:59 UTC", updated_at: "2012-03-28 14:53:59 UTC" )
    invoice_item_4 = invoice_1.invoice_items.create(item: item_1, quantity: 4, unit_price: '10.00', created_at: "2012-03-28 14:53:59 UTC", updated_at: "2012-03-28 14:53:59 UTC" )
    invoice_item_5 = invoice_2.invoice_items.create(item: item_2, quantity: 2, unit_price: '15.00', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC" )
    invoice_item_6 = invoice_3.invoice_items.create(item: item_3, quantity: 1, unit_price: '20.00', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC" )


    get '/api/v1/invoice_items/random'

    expect(response).to be_successful
    invoice_items = InvoiceItem.all.pluck(:id)
    invoice_item = JSON.parse(response.body)
    expect(invoice_items).to include(invoice_item["data"]["id"].to_i)
  end

  it 'can get an invoice_items item' do
    merchant = create(:merchant)
    customer = create(:customer)
    invoice_1 = merchant.invoices.create(customer: customer, status: 'shipped', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC")
    invoice_2 = merchant.invoices.create(customer: customer, status: 'packaged', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC")
    invoice_3 = merchant.invoices.create(customer: customer, status: 'cancelled', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC")
    item_1 = merchant.items.create(name: 'Teddy Bear', description: 'Fluffy', unit_price: '10.00')
    item_2 = merchant.items.create(name: 'Barbie', description: 'Basic', unit_price: '15.00')
    item_3 = merchant.items.create(name: 'Scooter', description: 'Vroom', unit_price: '20.00')

    invoice_item_1 = invoice_1.invoice_items.create(item: item_1, quantity: 4, unit_price: '10.00', created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC" )

    get "/api/v1/invoice_items/#{invoice_item_1.id}/item"

    expect(response).to be_successful
    item = JSON.parse(response.body)
    expect(item["data"]["id"]).to eq("#{item_1.id}")
  end

  it 'can get an invoice_items invoice' do
    merchant = create(:merchant)
    customer = create(:customer)
    invoice_1 = merchant.invoices.create(customer: customer, status: 'shipped', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC")
    invoice_2 = merchant.invoices.create(customer: customer, status: 'packaged', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC")
    invoice_3 = merchant.invoices.create(customer: customer, status: 'cancelled', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC")
    item_1 = merchant.items.create(name: 'Teddy Bear', description: 'Fluffy', unit_price: '10.00')
    item_2 = merchant.items.create(name: 'Barbie', description: 'Basic', unit_price: '15.00')
    item_3 = merchant.items.create(name: 'Scooter', description: 'Vroom', unit_price: '20.00')

    invoice_item_1 = invoice_1.invoice_items.create(item: item_1, quantity: 4, unit_price: '10.00', created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC" )

    get "/api/v1/invoice_items/#{invoice_item_1.id}/invoice"

    expect(response).to be_successful
    item = JSON.parse(response.body)
    expect(item["data"]["id"]).to eq("#{invoice_1.id}")
  end
end
