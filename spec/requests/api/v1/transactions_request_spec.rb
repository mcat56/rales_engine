require 'rails_helper'
# do sad paths / find / find_all errors
describe 'Transactions API' do
  it 'sends a list of transactions' do
    create_list(:transaction, 3)

    get '/api/v1/transactions'

    expect(response).to be_successful

    transactions = JSON.parse(response.body)
    expect(transactions["data"].length).to eq(3)
  end

  it 'can get show a transaction' do
    id = create(:transaction).id

    get "/api/v1/transactions/#{id}"

    invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice["data"]["id"].to_i).to eq(id)
  end

  it 'can find a transaction by any parameter' do
    merchant = create(:merchant)
    customer = create(:customer)
    invoice_1 = merchant.invoices.create(customer: customer, status: 'shipped', created_at: "2012-03-22 14:53:59 UTC", updated_at: "2012-03-22 14:53:59 UTC")
    invoice_2 = merchant.invoices.create(customer: customer, status: 'shipped', created_at: "2012-03-22 14:53:59 UTC", updated_at: "2012-03-22 14:53:59 UTC")
    invoice_3 = merchant.invoices.create(customer: customer, status: 'shipped', created_at: "2012-03-22 14:53:59 UTC", updated_at: "2012-03-22 14:53:59 UTC")

    transaction_1 = invoice_1.transactions.create(credit_card_number: '4654405418249632', result: 'success', created_at: "2012-03-22 14:53:59 UTC", updated_at: "2012-03-22 14:53:59 UTC")
    transaction_2 = invoice_2.transactions.create(credit_card_number: '4515551623735607', result: 'failure', created_at: "2012-03-24 14:53:59 UTC", updated_at: "2012-03-24 14:53:59 UTC")
    transaction_3 = invoice_3.transactions.create(credit_card_number: '4513421623735607', result: 'pending', created_at: "2012-03-26 14:53:59 UTC", updated_at: "2012-03-26 14:53:59 UTC")

    #find by id
    get "/api/v1/transactions/find?id=#{transaction_1.id}"

    transaction_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transaction_response["data"]["attributes"]["id"]).to eq(transaction_1.id)

    #find by result
    get "/api/v1/transactions/find?result=#{transaction_2.result}"

    transaction_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transaction_response["data"]["attributes"]["id"]).to eq(transaction_2.id)

    #find by invoice id
    get "/api/v1/transactions/find?invoice_id=#{transaction_3.invoice.id}"

    transaction_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transaction_response["data"]["attributes"]["id"]).to eq(transaction_3.id)

    #find by credit card number
    get "/api/v1/transactions/find?credit_card_number=#{transaction_1.credit_card_number}"

    transaction_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transaction_response["data"]["attributes"]["id"]).to eq(transaction_1.id)

    #find by created_at
    get "/api/v1/transactions/find?created_at=#{transaction_1.created_at}"

    transaction_response = JSON.parse(response.body)
    expect(response).to be_successful
    expect(transaction_response["data"]["attributes"]["id"]).to eq(transaction_1.id)

    #find by updated_at
    get "/api/v1/transactions/find?updated_at=#{transaction_2.updated_at}"

    transaction_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transaction_response["data"]["attributes"]["id"]).to eq(transaction_2.id)
  end

  it 'can find all transactions by any parameter' do
    merchant = create(:merchant)
    customer = create(:customer)
    invoice_1 = merchant.invoices.create(customer: customer, status: 'shipped', created_at: "2012-03-22 14:53:59 UTC", updated_at: "2012-03-22 14:53:59 UTC")
    invoice_2 = merchant.invoices.create(customer: customer, status: 'shipped', created_at: "2012-03-22 14:53:59 UTC", updated_at: "2012-03-22 14:53:59 UTC")
    invoice_3 = merchant.invoices.create(customer: customer, status: 'shipped', created_at: "2012-03-22 14:53:59 UTC", updated_at: "2012-03-22 14:53:59 UTC")

    transaction_1 = invoice_1.transactions.create(credit_card_number: '4654405418249632', result: 'success', created_at: "2012-03-22 14:53:59 UTC", updated_at: "2012-03-22 14:53:59 UTC")
    transaction_2 = invoice_1.transactions.create(credit_card_number: '4515551623735607', result: 'failure', created_at: "2012-03-24 14:53:59 UTC", updated_at: "2012-03-24 14:53:59 UTC")
    transaction_3 = invoice_2.transactions.create(credit_card_number: '4515551623735607', result: 'pending', created_at: "2012-03-26 14:53:59 UTC", updated_at: "2012-03-26 14:53:59 UTC")
    transaction_4 = invoice_2.transactions.create(credit_card_number: '4654405418249632', result: 'success', created_at: "2012-03-22 14:53:59 UTC", updated_at: "2012-03-22 14:53:59 UTC")
    transaction_5 = invoice_3.transactions.create(credit_card_number: '4515551623735607', result: 'failure', created_at: "2012-03-24 14:53:59 UTC", updated_at: "2012-03-24 14:53:59 UTC")
    transaction_6 = invoice_3.transactions.create(credit_card_number: '4515551623735607', result: 'pending', created_at: "2012-03-26 14:53:59 UTC", updated_at: "2012-03-26 14:53:59 UTC")


    get "/api/v1/transactions/find_all?id=#{transaction_1.id}"

    transaction_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transaction_response["data"]).to be_a(Array)
    expect(transaction_response["data"].first["id"]).to eq("#{transaction_1.id}")

   #find by result
    get "/api/v1/transactions/find_all?result=#{transaction_1.result}"

    transaction_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transaction_response["data"].length).to eq(2)
    expect(transaction_response["data"].first["id"]).to eq("#{transaction_1.id}")
    expect(transaction_response["data"][1]["id"]).to eq("#{transaction_4.id}")

    #find by invoice id
    get "/api/v1/transactions/find_all?invoice_id=#{transaction_3.invoice.id}"

    transaction_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transaction_response["data"].length).to eq(2)
    expect(transaction_response["data"].first["id"]).to eq("#{transaction_3.id}")
    expect(transaction_response["data"][1]["id"]).to eq("#{transaction_4.id}")

    #find by credit card number
    get "/api/v1/transactions/find_all?credit_card_number=#{transaction_2.credit_card_number}"

    transaction_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transaction_response["data"].length).to eq(4)
    expect(transaction_response["data"].first["id"]).to eq("#{transaction_2.id}")
    expect(transaction_response["data"][1]["id"]).to eq("#{transaction_3.id}")
    expect(transaction_response["data"][2]["id"]).to eq("#{transaction_5.id}")
    expect(transaction_response["data"][3]["id"]).to eq("#{transaction_6.id}")

    #find by updated_at
    get "/api/v1/transactions/find_all?updated_at=#{transaction_1.updated_at}"

    transaction_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transaction_response["data"].length).to eq(2)
    expect(transaction_response["data"].first["id"]).to eq("#{transaction_1.id}")
    expect(transaction_response["data"][1]["id"]).to eq("#{transaction_4.id}")

    #find by created at
    get "/api/v1/transactions/find_all?created_at=#{transaction_2.created_at}"

    transaction_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transaction_response["data"].length).to eq(2)
    expect(transaction_response["data"].first["id"]).to eq("#{transaction_2.id}")
    expect(transaction_response["data"][1]["id"]).to eq("#{transaction_5.id}")
  end

  it 'can select a random transaction' do
    merchant = create(:merchant)
    customer = create(:customer)
    invoice_1 = merchant.invoices.create(customer: customer, status: 'shipped', created_at: "2012-03-22 14:53:59 UTC", updated_at: "2012-03-22 14:53:59 UTC")
    invoice_2 = merchant.invoices.create(customer: customer, status: 'shipped', created_at: "2012-03-22 14:53:59 UTC", updated_at: "2012-03-22 14:53:59 UTC")
    invoice_3 = merchant.invoices.create(customer: customer, status: 'shipped', created_at: "2012-03-22 14:53:59 UTC", updated_at: "2012-03-22 14:53:59 UTC")

    transaction_1 = invoice_1.transactions.create(credit_card_number: '4654405418249632', result: 'success', created_at: "2012-03-22 14:53:59 UTC", updated_at: "2012-03-22 14:53:59 UTC")
    transaction_2 = invoice_2.transactions.create(credit_card_number: '4515551623735607', result: 'failure', created_at: "2012-03-24 14:53:59 UTC", updated_at: "2012-03-24 14:53:59 UTC")
    transaction_3 = invoice_3.transactions.create(credit_card_number: '4513421623735607', result: 'pending', created_at: "2012-03-26 14:53:59 UTC", updated_at: "2012-03-26 14:53:59 UTC")

    get '/api/v1/transactions/random'

    expect(response).to be_successful
    transactions = Transaction.all.pluck(:id)
    transaction = JSON.parse(response.body)
    expect(transactions).to include(transaction["data"]["id"].to_i)
  end

  it 'can return a transactions invoice' do
    merchant = create(:merchant)
    customer = create(:customer)
    invoice_1 = merchant.invoices.create(customer: customer, status: 'shipped', created_at: "2012-03-22 14:53:59 UTC", updated_at: "2012-03-22 14:53:59 UTC")
    invoice_2 = merchant.invoices.create(customer: customer, status: 'shipped', created_at: "2012-03-22 14:53:59 UTC", updated_at: "2012-03-22 14:53:59 UTC")
    invoice_3 = merchant.invoices.create(customer: customer, status: 'shipped', created_at: "2012-03-22 14:53:59 UTC", updated_at: "2012-03-22 14:53:59 UTC")

    transaction_1 = invoice_1.transactions.create(credit_card_number: '4654405418249632', result: 'success', created_at: "2012-03-22 14:53:59 UTC", updated_at: "2012-03-22 14:53:59 UTC")

    get "/api/v1/transactions/#{transaction_1.id}/invoice"

    expect(response).to be_successful
    invoice = JSON.parse(response.body)
    expect(invoice["data"]["id"]).to eq("#{invoice_1.id}") 
  end
end
