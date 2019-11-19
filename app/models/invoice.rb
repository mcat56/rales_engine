class Invoice < ApplicationRecord
  validates_presence_of :status
  has_many :transactions
  has_many :invoice_items
  belongs_to :customer
  belongs_to :merchant

  require 'csv'
  require 'activerecord-import/base'
  require 'activerecord-import/active_record/adapters/postgresql_adapter'

  def self.import(file)
    invoices = []
    CSV.foreach('./data/invoices.csv', headers: true ) do |row|
      invoices << Invoice.new(row.to_h)
    end
    Invoice.import invoices, recursive: true
  end
end
