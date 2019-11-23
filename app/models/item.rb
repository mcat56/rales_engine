class Item < ActiveRecord::Base
  validates_presence_of :name, :description, :unit_price
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices

  acts_as_copy_target

  def self.top_items(quantity)
    Item.joins(invoices: :transactions).select("items.*, sum(invoice_items.unit_price * invoice_items.quantity) as total_revenue").merge(Transaction.successful).group(:id).order("total_revenue desc").limit(quantity)
  end

  def best_day
    invoices.joins(:transactions).select("invoices.*, sum(invoice_items.quantity) as total").merge(Transaction.successful).group("DATE_TRUNC('day', invoices.created_at), invoices.id").order("total desc, invoices.created_at desc").limit(1).first.created_at
  end
end
