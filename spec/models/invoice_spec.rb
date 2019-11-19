require 'rails_helper'

describe Invoice do
  describe 'validations' do
    it { should validate_presence_of :status }
  end

  describe 'relationships' do
    it { should belong_to :customer }
    it { should belong_to :merchant }
    it { should have_many :transactions }
    it { should have_many :items.through(:invoice_items)}
  end

  describe 'attributes' do
    it 'has attributes' do
      merchant = Merchant.create(name: 'ToysRUs')
      customer = Customer.create(first_name: 'Sonny', last_name: 'Moore')

      invoice = customer.invoices.create(merchant: merchant, status: 'shipped')
      expect(invoice.customer.first_name).to eq('Sonny')
      expect(invoice.merchant.name).to eq('ToysRUs')
      expect(invoice.status).to eq('shipped')
    end
  end
end
