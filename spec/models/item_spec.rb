require 'rails_helper'

describe Item do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
  end

  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many :invoices.through(:invoice_items)}
  end

  describe 'attributes' do
    it 'has attributes' do
      merchant = Merchant.create(name: 'ToysRUs')
      item = merchant.items.create(name: 'Teddy Bear', description: 'Fluffy', unit_price: 1200)

      expect(item.name).to eq('Teddy Bear')
      expect(item.description).to eq('Fluffy')
      expect(item.unit_price).to eq(1200)
    end
  end
end
