class Transaction < ActiveRecord::Base
  validates_presence_of :credit_card_number, :result
  belongs_to :invoice

  acts_as_copy_target 
end
