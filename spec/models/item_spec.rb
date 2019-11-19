require 'rails_helper'

describe Item do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
  end

  describe 'relationships' do
    it { should belong_to :merchant }
  end

  describe 'attributes' do
    merchant = Merchant.create(name: 'ToysRUs')
    item = merchant.items.create(name: 'Teddy Bear', description: 'fluffy', fluffy: 1200)

    expect(item.name).to eq('Teddy Bear')
    expect(item.description).to eq('Fluffy')
    expect(item.name).to eq(1200)
  end
end
