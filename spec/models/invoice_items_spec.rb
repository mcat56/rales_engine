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
    it 'has attributes' do
      merchant = Merchant.create(name: 'ToysRUs')
      customer = Customer.create(first_name: 'Sonny', last_name: 'Moore')
      item = merchant.items.create(name: 'Teddy Bear', description: 'Fluffy', unit_price: 1200)
      invoice = customer.invoices.create(merchant: merchant, status: 'shipped')

      invoice_item = invoice.invoice_items.create(item: item, quantity: 4, unit_price: 1200)
      expect(invoice_item.invoice.status).to eq('shipped')
      expect(invoice_item.item.name).to eq('Teddy Bear')
      expect(invoice_item.quantity).to eq(4)
      expect(invoice_item.unit_price).to eq(1200)
    end
  end
end
