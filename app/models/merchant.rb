class Merchant < ActiveRecord::Base
  validates_presence_of :name
  has_many :invoices
  has_many :items
  has_many :invoice_items, through: :invoices
  has_many :transactions, through: :invoices

  acts_as_copy_target

  def self.top_merchants(count)
    Merchant.joins(invoice_items: :transactions).select("merchants.*, sum(invoice_items.unit_price * invoice_items.quantity) as total_revenue").merge(Transaction.successful).group(:id).order("total_revenue desc").limit(count)
  end
end
