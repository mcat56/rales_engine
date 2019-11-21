class Item < ActiveRecord::Base
  validates_presence_of :name, :description, :unit_price
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices

  acts_as_copy_target

  def self.most_revenue(quantity)
    joins(invoices: :transactions).select("items.*, sum(invoice_items.unit_price * invoice_items.quantity) as total_revenue").merge(Transaction.successful).group(:id).order("total_revenue desc").limit(quantity)
  end
end
