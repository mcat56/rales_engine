require 'csv'
require 'activerecord-import/base'
require 'activerecord-import/active_record/adapters/postgresql_adapter'
require_relative '../../app/models/customer'
require_relative '../../app/models/item'
require_relative '../../app/models/merchant'
require_relative '../../app/models/invoice'
require_relative '../../app/models/invoice_item'
require_relative '../../app/models/transaction'

namespace :import do |import|
  desc 'Import customers'
  task :import_customers => :environment do
    customers = []
    CSV.foreach('data/customers.csv', headers: true ) do |row|
      customers << Customer.new(row.to_h)
    end
    Customer.import customers, recursive: true
  end

  desc 'Import merchants'
  task :import_merchants => :environment do
    merchants = []
    CSV.foreach('data/merchants.csv', headers: true ) do |row|
      merchants << Merchant.new(row.to_h)
    end
    Merchant.import merchants, recursive: true
  end

  desc 'Import items'
  task :import_items => :environment do
    items = []
    CSV.foreach('data/items.csv', headers: true ) do |row|
      items << Item.new(row.to_h)
    end
    Item.import items, recursive: true
  end


  desc 'Import invoices'
  task :import_invoices => :environment do
    invoices = []
    CSV.foreach('data/invoices.csv', headers: true ) do |row|
      invoices << Invoice.new(row.to_h)
    end
    Invoice.import invoices, recursive: true
  end

  desc 'Import invoice_items'
  task :import_invoice_items => :environment do
    invoice_items = []
    CSV.foreach('data/invoice_items.csv', headers: true ) do |row|
      invoice_items << InvoiceItem.new(row.to_h)
    end
    InvoiceItem.import invoice_items, recursive: true
  end

  desc 'Import transactions'
  task :import_transactions => :environment do
    transactions = []
    CSV.foreach('data/transactions.csv', headers: true ) do |row|
      transactions << Transaction.new(row.to_h)
    end
    Transaction.import transactions, recursive: true
  end

  desc 'All'
  task :all do
    import.tasks.each do |task|
      Rake::Task[task].invoke
    end
  end
end
