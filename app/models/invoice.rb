class Invoice < ApplicationRecord
  validates_presence_of :status
  has_many :transactions
  belongs_to :customer
  belongs_to :merchant

end
