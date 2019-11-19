require 'rails_helper'

describe Customer do
  describe 'validations' do
    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name }
  end

  describe 'relationships' do
    it { should have_many :invoices }
  end

  describe 'attributes' do
    it 'has attributes' do
      customer = Customer.create(first_name: 'Sonny', last_name: 'Moore')

      expect(customer.first_name).to eq('Sonny')
      expect(customer.last_name).to eq('Moore')
    end 
  end
end
