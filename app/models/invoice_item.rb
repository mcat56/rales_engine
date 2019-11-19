class InvoiceItem < ApplicationRecord
  validates_presence_of :quantity, :unit_price
  belongs_to :invoice
  belongs_to :item

  require 'csv'
  require 'activerecord-import/base'
  require 'activerecord-import/active_record/adapters/postgresql_adapter'

  def self.import(file)
    invoice_items = []
    CSV.foreach('./data/invoice_items.csv', headers: true ) do |row|
      invoice_items << InvoiceItem.new(row.to_h)
    end
    InvoiceItem.import invoice_items, recursive: true
  end
end
