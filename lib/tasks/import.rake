require 'csv'
require 'activerecord-import/base'
require 'activerecord-import/active_record/adapters/postgresql_adapter'
require_relative '../../app/models/customer'
require_relative '../../app/models/item'
require_relative '../../app/models/merchant'
require_relative '../../app/models/invoice'
require_relative '../../app/models/invoice_item'
require_relative '../../app/models/transaction'

desc 'import_files'
namespace :import do |import|
  task :import_data => :environment do
    customers = []
    CSV.foreach('data/customers.csv', headers: true ) do |row|
      customers << Customer.new(row.to_h)
    end
    Customer.import customers, recursive: true

    merchants = []
    CSV.foreach('data/merchants.csv', headers: true ) do |row|
      merchants << Merchant.new(row.to_h)
    end
    Merchant.import merchants, recursive: true

    items = []
    CSV.foreach('data/items.csv', headers: true ) do |row|
      items << Item.new(row.to_h)
    end
    items.each do |item|
      item.unit_price =  (item.unit_price * 0.01)
    end
    Item.import items, recursive: true

    invoices = []
    CSV.foreach('data/invoices.csv', headers: true ) do |row|
      invoices << Invoice.new(row.to_h)
    end
    Invoice.import invoices, recursive: true

    invoice_items = []
    CSV.foreach('data/invoice_items.csv', headers: true ) do |row|
      invoice_items << InvoiceItem.new(row.to_h)
    end
    invoice_items.each do |invoice_item|
      invoice_item.unit_price =  ( '%.2f' % (invoice_item.unit_price * 0.01))
    end
    InvoiceItem.import invoice_items, recursive: true

    transactions = []
    CSV.foreach('data/transactions.csv', headers: true ) do |row|
      transactions << Transaction.new(row.to_h)
    end
    Transaction.import transactions, recursive: true
  end
end
