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

  def customers_with_pending_invoices
    Customer.find_by_sql("SELECT customers.* FROM customers inner join invoices on invoices.customer_id = customers.id where invoices.merchant_id = #{self.id} except all select customers.* FROM customers inner join invoices on customers.id = invoices.customer_id inner join transactions on invoices.id = transactions.invoice_id where invoices.merchant_id = #{self.id}  and transactions.result = 'success' group by invoices.id, customers.id having count(transactions.*) >= 1")
  end
end
