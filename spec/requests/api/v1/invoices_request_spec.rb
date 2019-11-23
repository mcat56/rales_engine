require 'rails_helper'
# do sad paths / find / find_all errors
describe 'Invoices API' do
  it 'sends a list of invoices' do
    create_list(:invoice, 3)

    get '/api/v1/invoices'

    expect(response).to be_successful

    invoices = JSON.parse(response.body)
    expect(invoices["data"].length).to eq(3)
  end

  it 'can get show a invoice' do
    id = create(:invoice).id

    get "/api/v1/invoices/#{id}"

    invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice["data"]["id"].to_i).to eq(id)
  end

  it 'can find a invoice by any parameter' do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    merchant_3 = create(:merchant)
    customer_1 = create(:customer)
    customer_2 = create(:customer)
    customer_3 = create(:customer)
    invoice_1 = merchant_1.invoices.create(customer: customer_1, status: 'shipped', created_at: "2012-03-22 14:53:59 UTC", updated_at: "2012-03-22 14:53:59 UTC")
    invoice_2 = merchant_2.invoices.create(customer: customer_2, status: 'packaged', created_at: "2012-03-24 14:53:59 UTC", updated_at: "2012-03-24 14:53:59 UTC")
    invoice_3 = merchant_3.invoices.create(customer: customer_3, status: 'cancelled', created_at: "2012-03-25 14:53:59 UTC", updated_at: "2012-03-25 14:53:59 UTC")

    #find by id
    get "/api/v1/invoices/find?id=#{invoice_1.id}"

    invoice_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_response["data"]["attributes"]["id"]).to eq(invoice_1.id)

    #find by last_name
    get "/api/v1/invoices/find?status=#{invoice_2.status}"

    invoice_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_response["data"]["attributes"]["id"]).to eq(invoice_2.id)

    #find by merchant
    get "/api/v1/invoices/find?merchant_id=#{invoice_3.merchant.id}"

    invoice_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_response["data"]["attributes"]["id"]).to eq(invoice_3.id)

    #find by customer
    get "/api/v1/invoices/find?customer_id=#{invoice_2.customer.id}"

    invoice_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_response["data"]["attributes"]["id"]).to eq(invoice_2.id)

    #find by created_at
    get "/api/v1/invoices/find?created_at=#{invoice_1.created_at}"

    invoice_response = JSON.parse(response.body)
    expect(response).to be_successful
    expect(invoice_response["data"]["attributes"]["id"]).to eq(invoice_1.id)

    #find by updated_at
    get "/api/v1/invoices/find?updated_at=#{invoice_2.updated_at}"

    invoice_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_response["data"]["attributes"]["id"]).to eq(invoice_2.id)
  end

  it 'can find all invoices by any parameter' do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    merchant_3 = create(:merchant)
    customer_1 = create(:customer)
    customer_2 = create(:customer)
    customer_3 = create(:customer)
    invoice_1 = merchant_1.invoices.create(customer: customer_1, status: 'shipped', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC")
    invoice_2 = merchant_2.invoices.create(customer: customer_2, status: 'packaged', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC")
    invoice_3 = merchant_3.invoices.create(customer: customer_3, status: 'cancelled', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC")
    invoice_4 = merchant_1.invoices.create(customer: customer_1, status: 'shipped', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC")
    invoice_5 = merchant_2.invoices.create(customer: customer_2, status: 'packaged', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC")
    invoice_6 = merchant_3.invoices.create(customer: customer_3, status: 'cancelled', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC")
    invoice_7 = merchant_1.invoices.create(customer: customer_1, status: 'shipped', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC")
    invoice_8 = merchant_2.invoices.create(customer: customer_2, status: 'packaged', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC")
    invoice_9 = merchant_3.invoices.create(customer: customer_3, status: 'cancelled', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC")

    invoices = Invoice.all

    get "/api/v1/invoices/find_all?id=#{invoice_1.id}"

    invoice_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_response["data"]).to be_a(Array)
    expect(invoice_response["data"].first["id"]).to eq("#{invoice_1.id}")

   #find by status
    get "/api/v1/invoices/find_all?status=#{invoice_1.status}"

    invoice_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_response["data"].length).to eq(3)
    expect(invoice_response["data"].first["id"]).to eq("#{invoice_1.id}")
    expect(invoice_response["data"][1]["id"]).to eq("#{invoice_4.id}")
    expect(invoice_response["data"][2]["id"]).to eq("#{invoice_7.id}")

    #find by merchant_id
    get "/api/v1/invoices/find_all?merchant_id=#{invoice_2.merchant.id}"

    invoice_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_response["data"].length).to eq(3)
    expect(invoice_response["data"].first["id"]).to eq("#{invoice_2.id}")
    expect(invoice_response["data"][1]["id"]).to eq("#{invoice_5.id}")
    expect(invoice_response["data"][2]["id"]).to eq("#{invoice_8.id}")

    #find by customer id
    get "/api/v1/invoices/find_all?customer_id=#{invoice_3.customer.id}"

    invoice_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_response["data"].length).to eq(3)
    expect(invoice_response["data"].first["id"]).to eq("#{invoice_3.id}")
    expect(invoice_response["data"][1]["id"]).to eq("#{invoice_6.id}")
    expect(invoice_response["data"][2]["id"]).to eq("#{invoice_9.id}")
  end

  it 'can select a random invoice' do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    merchant_3 = create(:merchant)
    customer_1 = create(:customer)
    customer_2 = create(:customer)
    customer_3 = create(:customer)
    invoice_1 = merchant_1.invoices.create(customer: customer_1, status: 'shipped', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC")
    invoice_2 = merchant_2.invoices.create(customer: customer_2, status: 'packaged', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC")
    invoice_3 = merchant_3.invoices.create(customer: customer_3, status: 'cancelled', created_at: "2012-03-29 14:53:59 UTC", updated_at: "2012-03-29 14:53:59 UTC")


    get '/api/v1/invoices/random'

    expect(response).to be_successful
    invoices = Invoice.all.pluck(:id)
    invoice = JSON.parse(response.body)
    expect(invoices).to include(invoice["data"]["id"].to_i)
  end

  it 'can get an invoices merchant' do
    merchant = create(:merchant)
    customer = create(:customer)
    invoice = merchant.invoices.create(customer: customer, status: 'shipped', created_at: "2012-03-22 14:53:59 UTC", updated_at: "2012-03-22 14:53:59 UTC")

    get "/api/v1/invoices/#{invoice.id}/merchant"

    expect(response).to be_successful
    merchant_response = JSON.parse(response.body)
    expect(merchant_response["data"]["id"]).to eq("#{merchant.id}")
  end

  it 'can get an invoices customer' do
    merchant = create(:merchant)
    customer = create(:customer)
    invoice = merchant.invoices.create(customer: customer, status: 'shipped', created_at: "2012-03-22 14:53:59 UTC", updated_at: "2012-03-22 14:53:59 UTC")

    get "/api/v1/invoices/#{invoice.id}/customer"

    expect(response).to be_successful
    customer_response = JSON.parse(response.body)
    expect(customer_response["data"]["id"]).to eq("#{customer.id}")
  end

  it 'can get an invoices invoice_items' do
    merchant = create(:merchant)
    customer = create(:customer)
    invoice = merchant.invoices.create(customer: customer, status: 'shipped', created_at: "2012-03-22 14:53:59 UTC", updated_at: "2012-03-22 14:53:59 UTC")

    item_1 = merchant.items.create(name: 'Teddy Bear', description: 'Fluffy', unit_price: '12.00')
    item_2 = merchant.items.create(name: 'Barbie', description: 'Basic', unit_price: '20.00')
    item_3 = merchant.items.create(name: 'Scooter', description: 'Vroom', unit_price: '35.00')

    invoice_1 = customer.invoices.create(merchant: merchant, status: 'shipped')
    invoice_item_1 = invoice.invoice_items.create(item: item_1, quantity: 4, unit_price: '12.00')
    invoice_item_2 = invoice.invoice_items.create(item: item_2, quantity: 3, unit_price: '20.00')
    invoice_item_3 = invoice.invoice_items.create(item: item_3, quantity: 1, unit_price: '35.00')

    get "/api/v1/invoices/#{invoice.id}/invoice_items"

    expect(response).to be_successful
    invoice_items = JSON.parse(response.body)
    expect(invoice_items["data"].length).to eq(3)
    expect(invoice_items["data"].first["id"]).to eq("#{invoice_item_1.id}")
  end

  it 'can get an invoices transactions' do
    merchant = create(:merchant)
    customer = create(:customer)
    invoice = merchant.invoices.create(customer: customer, status: 'shipped', created_at: "2012-03-22 14:53:59 UTC", updated_at: "2012-03-22 14:53:59 UTC")

    transaction_1 = invoice.transactions.create(credit_card_number: '4654405418249632', result: 'success')
    transaction_2 = invoice.transactions.create(credit_card_number: '4515551623735607', result: 'failure')
    transaction_3 = invoice.transactions.create(credit_card_number: '4515551623735607', result: 'failure')
    transaction_4 = invoice.transactions.create(credit_card_number: '4923661117104166', result: 'success')
    transaction_5 = invoice.transactions.create(credit_card_number: '4003216997806204', result: 'success')
    transaction_6 = invoice.transactions.create(credit_card_number: '4339360234330200', result: 'success')

    get "/api/v1/invoices/#{invoice.id}/transactions"

    expect(response).to be_successful
    invoice_items = JSON.parse(response.body)
    expect(invoice_items["data"].length).to eq(6)
    expect(invoice_items["data"].first["id"]).to eq("#{transaction_1.id}")
  end

  it 'can get an invoices items' do
    merchant = create(:merchant)
    customer = create(:customer)
    invoice = merchant.invoices.create(customer: customer, status: 'shipped', created_at: "2012-03-22 14:53:59 UTC", updated_at: "2012-03-22 14:53:59 UTC")

    item_1 = merchant.items.create(name: 'Teddy Bear', description: 'Fluffy', unit_price: '12.00')
    item_2 = merchant.items.create(name: 'Barbie', description: 'Basic', unit_price: '20.00')
    item_3 = merchant.items.create(name: 'Scooter', description: 'Vroom', unit_price: '35.00')

    invoice_1 = customer.invoices.create(merchant: merchant, status: 'shipped')
    invoice_item_1 = invoice.invoice_items.create(item: item_1, quantity: 4, unit_price: '12.00')
    invoice_item_2 = invoice.invoice_items.create(item: item_2, quantity: 3, unit_price: '20.00')
    invoice_item_3 = invoice.invoice_items.create(item: item_3, quantity: 1, unit_price: '35.00')

    get "/api/v1/invoices/#{invoice.id}/items"

    expect(response).to be_successful
    invoice_items = JSON.parse(response.body)
    expect(invoice_items["data"].length).to eq(3)
    expect(invoice_items["data"].first["id"]).to eq("#{item_1.id}")
  end
end
