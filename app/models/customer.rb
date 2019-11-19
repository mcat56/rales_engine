class Customer < ActiveRecord::Base
  validates_presence_of :first_name, :last_name
  has_many :invoices
  has_many :transactions, through: :invoices


  acts_as_copy_target

end
