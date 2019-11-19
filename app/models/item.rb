class Item < ActiveRecord::Base
  validates_presence_of :name, :description, :unit_price
  belongs_to :merchant
  has_many :invoices, through: :invoice_items

  acts_as_copy_target
end
