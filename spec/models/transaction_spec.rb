require 'rails_helper'

describe Transaction do
  describe 'validations' do
    it { should validate_presence_of :credit_card_number }
    it { should validate_presence_of :result }
  end

  describe 'relationships' do
    it { should belong_to :invoice }
  end

  describe 'attributes' do
    merchant = Merchant.create(name: 'ToysRUs')
    customer = Customer.create(first_name: 'Sonny', last_name: 'Moore')
    invoice = customer.invoices.create(merchant: merchant, status: 'shipped')


    transaction = invoice.transactions.create(credit_card_number: 4654405418249632, result: 'success')
    expect(transaction.credit_card_number).to eq(4654405418249632)
    expect(transaction.result).to eq('success')
  end
end
