require 'rails_helper'

describe 'Items API' do
  it 'sends a list of customers' do
    create_list(:customer, 3)

    get '/api/v1/customers'

    expect(response).to be_successful

    customers = JSON.parse(response.body)
    expect(customers["data"].length).to eq(3)
  end

  it 'can get one item by its id' do
    id = create(:customer).id

    get "/api/v1/customers/#{id}"

    customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer["data"]["id"].to_i).to eq(id)
  end

  it 'can find an item by any parameter' do
    create_list(:customer, 3)

    customer = Customer.last

    get "/api/v1/customers/find?first_name=#{customer.first_name}"

    customer_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer_response["data"].first["attributes"]["first_name"]).to eq("#{customer.first_name}")

    get "/api/v1/customers/find?last_name=#{customer.last_name}"

    customer_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer_response["data"].first["attributes"]["first_name"]).to eq("#{customer.first_name}")

    get "/api/v1/customers/find?id=#{customer.id}"

    customer_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer_response["data"].first["attributes"]["first_name"]).to eq("#{customer.first_name}")
  end

  it 'can find all items by any parameter' do

  end
end
