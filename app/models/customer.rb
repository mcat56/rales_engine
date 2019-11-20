class Customer < ActiveRecord::Base
  validates_presence_of :first_name, :last_name
  has_many :invoices
  has_many :transactions, through: :invoices


  acts_as_copy_target


  def favorite_merchant
    invoices.joins(:transactions).merge(Transaction.successful).joins(:merchant).select('merchants.id').group('merchants.id').order('count(transactions.*) desc').limit(1).first
  end

end

# invoices.joins(transactions: :merchants)
