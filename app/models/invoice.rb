class Invoice < ActiveRecord::Base
  validates_presence_of :status
  has_many :transactions
  has_many :invoice_items
  belongs_to :customer
  belongs_to :merchant

  acts_as_copy_target 
end
