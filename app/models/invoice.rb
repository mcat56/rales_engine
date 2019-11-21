class Invoice < ActiveRecord::Base
  validates_presence_of :status
  has_many :transactions
  belongs_to :customer
  belongs_to :merchant
  has_many :invoice_items
  has_many :items, through: :invoice_items

  acts_as_copy_target

  def total_revenue
    binding.pry
  end
end
