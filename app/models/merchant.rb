class Merchant < ActiveRecord::Base
  validates_presence_of :name
  has_many :invoices
  has_many :items

  acts_as_copy_target 
end
