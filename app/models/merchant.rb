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

  def self.revenue_by_date(date)
    date = date.to_date.all_day
    Invoice.joins(:invoice_items, :transactions).merge(Transaction.successful).where({invoices: { created_at: date } } ).sum('invoice_items.unit_price * invoice_items.quantity')
  end

  def favorite_customer
    Customer.joins(:transactions).where("merchant_id = #{self.id}").merge(Transaction.successful).select("customers.*, count(transactions.*)").group('customers.id').order('count desc').limit(1).first
  end
end
