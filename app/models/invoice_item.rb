class InvoiceItem < ActiveRecord::Base
  validates_presence_of :quantity, :unit_price
  belongs_to :invoice
  belongs_to :item

  acts_as_copy_target 
end
