class Customer < ApplicationRecord
  validates_presence_of :first_name, :last_name
  has_many :invoices

  require 'csv'
  require 'activerecord-import/base'
  require 'activerecord-import/active_record/adapters/postgresql_adapter'

  def self.import(file)
    customers = []
    CSV.foreach('./data/customers.csv', headers: true ) do |row|
      customers << Customer.new(row.to_h)
    end
    Customer.import customers, recursive: true
  end

end
