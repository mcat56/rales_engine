require 'rails_helper'

describe Merchant do
  describe 'validations' do
    it { should validate_presence_of :name }
  end

  describe 'relationships' do
    it { should have_many :items }
    it { should have_many :invoices }
    it { should have_many(:invoice_items).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe 'attributes' do
    it 'has attributes' do
      merchant = Merchant.create(name: 'ToysRUs')

      expect(merchant.name).to eq('ToysRUs')
    end
  end
end
