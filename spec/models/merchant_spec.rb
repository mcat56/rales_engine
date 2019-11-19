require 'rails_helper'

describe Merchant do
  describe 'validations' do
    it { should validate_presence_of :name }
  end

  describe 'relationships' do
    it { should have_many :items }
    it { should have_many :invoices }
  end

  describe 'attributes' do
    merchant = Merchant.create(name: 'ToysRUs')

    expect(merchant.name).to eq('ToysRUs')
  end
end
