require 'rails_helper'

describe InvoiceItem do
  describe 'validations' do
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :unit_price }
  end

  describe 'relationships' do
    it { should belong_to :item }
    it { should belong_to :invoice }
  end

  describe 'attributes' do
    merchant = Merchant.create(name: 'ToysRUs')
    customer = Customer.create(first_name: 'Sonny', last_name: 'Moore')

    invoice = customer.invoices.create(merchant: merchant, status: 'shipped')
    expect(invoice.customer.first_name).to eq('Sonny')
    expect(invoice.merchant.name).to eq('ToysRUs')
    expect(invoice.status).to eq('shipped')
  end
end
