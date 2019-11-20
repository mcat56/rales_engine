require 'rails_helper'
# do sad paths / find / find_all errors
describe 'Items API' do
  it 'sends a list of customers' do
    create_list(:customer, 3)

    get '/api/v1/customers'

    expect(response).to be_successful

    customers = JSON.parse(response.body)
    expect(customers["data"].length).to eq(3)
  end

  it 'can get show a customer' do
    id = create(:customer).id

    get "/api/v1/customers/#{id}"

    customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer["data"]["id"].to_i).to eq(id)
  end

  it 'can find a customer by any parameter' do
    customer_1 = Customer.create(first_name: 'Sonny', last_name: 'Moore', created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC" )
    customer_2 = Customer.create(first_name: 'Alice', last_name: 'Wonderland', created_at: "2014-03-27 14:53:59 UTC", updated_at: "2014-03-27 14:53:59 UTC" )
    customer_3 = Customer.create(first_name: 'Huckleberry', last_name: 'Finn', created_at: "2016-03-27 14:53:59 UTC", updated_at: "2016-03-27 14:53:59 UTC" )

    #find by first_name
    get "/api/v1/customers/find?first_name=#{customer_1.first_name}"

    customer_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer_response["data"].first["attributes"]["first_name"]).to eq("#{customer_1.first_name}")

    #find by last_name
    get "/api/v1/customers/find?last_name=#{customer_2.last_name}"

    customer_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer_response["data"].first["attributes"]["first_name"]).to eq("#{customer_2.first_name}")

    #find by id
    get "/api/v1/customers/find?id=#{customer_3.id}"

    customer_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer_response["data"].first["attributes"]["first_name"]).to eq("#{customer_3.first_name}")

    #find by created_at
    get "/api/v1/customers/find?created_at=#{customer_1.created_at}"

    customer_response = JSON.parse(response.body)
    expect(response).to be_successful
    expect(customer_response["data"].first["attributes"]["first_name"]).to eq("#{customer_1.first_name}")

    #find by updated_at
    get "/api/v1/customers/find?updated_at=#{customer_2.updated_at}"

    customer_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer_response["data"].first["attributes"]["first_name"]).to eq("#{customer_2.first_name}")
  end

  it 'can find all customers by any parameter' do
    customer_1 = Customer.create(first_name: 'Lucy', last_name: 'Ripley')
    customer_2 = Customer.create(first_name: 'Lucy', last_name: 'Ripley')
    customer_3 = Customer.create(first_name: 'Lucy', last_name: 'Ripley')

    customers = Customer.all

    get "/api/v1/customers/find_all?first_name=#{customer_1.first_name}"

    customer_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer_response["data"].length).to eq(3)
    expect(customer_response["data"].first["id"]).to eq("#{customer_1.id}")
    expect(customer_response["data"][1]["id"]).to eq("#{customer_2.id}")
    expect(customer_response["data"][2]["id"]).to eq("#{customer_3.id}")


    get "/api/v1/customers/find_all?last_name=#{customer_1.last_name}"

    customer_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer_response["data"].length).to eq(3)
    expect(customer_response["data"].first["id"]).to eq("#{customer_1.id}")
    expect(customer_response["data"][1]["id"]).to eq("#{customer_2.id}")
    expect(customer_response["data"][2]["id"]).to eq("#{customer_3.id}")


    get "/api/v1/customers/find_all?id=#{customer_1.id}"

    customer_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer_response["data"]).to be_a(Array)
  end

  it 'can select a random customer' do
    customer = Customer.create(first_name: 'Lucy', last_name: 'Ripley')

    get '/api/v1/customers/random'

    expect(response).to be_successful

    customer_response = JSON.parse(response.body)
    expect(customer_response["data"]["attributes"]["first_name"]).to eq('Lucy')
  end

  it 'can get a customers invoices' do
    customer = create(:customer)
    merchant = create(:merchant)
    invoice_1 = customer.invoices.create(merchant: merchant, status: 'shipped')
    invoice_2 = customer.invoices.create(merchant: merchant, status: 'shipped')
    invoice_3 = customer.invoices.create(merchant: merchant, status: 'shipped')
    invoice_4 = customer.invoices.create(merchant: merchant, status: 'shipped')

    get "/api/v1/customers/#{customer.id}/invoices"

    invoices = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoices["data"].length).to eq(4)
  end

  it 'can get a customers transactions' do
    customer = create(:customer)
    merchant = create(:merchant)
    invoice_1 = customer.invoices.create(merchant: merchant, status: 'shipped')
    invoice_2 = customer.invoices.create(merchant: merchant, status: 'shipped')
    invoice_3 = customer.invoices.create(merchant: merchant, status: 'shipped')

    transaction_1 = invoice_1.transactions.create(credit_card_number: 4654405418249632, result: 'success')
    transaction_2 = invoice_2.transactions.create(credit_card_number: 4515551623735607, result: 'success')
    transaction_3 = invoice_3.transactions.create(credit_card_number: 4923661117104166, result: 'success')

    get "/api/v1/customers/#{customer.id}/transactions"

    transactions = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transactions["data"].length).to eq(3)
    expect(transactions["data"].first["attributes"]["last_four"]).to eq(9632)
  end

  it 'can get a customers favorite merchant' do
    customer = create(:customer)
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    merchant_3 = create(:merchant)
    invoice_1 = customer.invoices.create(merchant: merchant_1, status: 'shipped')
    invoice_2 = customer.invoices.create(merchant: merchant_1, status: 'shipped')
    invoice_3 = customer.invoices.create(merchant: merchant_1, status: 'shipped')
    invoice_4 = customer.invoices.create(merchant: merchant_2, status: 'shipped')
    invoice_5 = customer.invoices.create(merchant: merchant_3, status: 'shipped')
    invoice_6 = customer.invoices.create(merchant: merchant_3, status: 'shipped')

    transaction_1 = invoice_1.transactions.create(credit_card_number: 4654405418249632, result: 'success')
    transaction_2 = invoice_2.transactions.create(credit_card_number: 4515551623735607, result: 'failure')
    transaction_3 = invoice_3.transactions.create(credit_card_number: 4515551623735607, result: 'failure')
    transaction_4 = invoice_4.transactions.create(credit_card_number: 4923661117104166, result: 'success')
    transaction_5 = invoice_5.transactions.create(credit_card_number: 4003216997806204, result: 'success')
    transaction_6 = invoice_6.transactions.create(credit_card_number: 4339360234330200, result: 'success')

    get "/api/v1/customers/#{customer.id}/favorite_merchant"

    favorite_merchant = JSON.parse(response.body)
    expect(response).to be_successful
    expect(favorite_merchant["data"]["attributes"]["name"]).to eq("#{merchant_3.name}")

  end
end
