require 'csv'
require_relative '../../app/models/customer'
require_relative '../../app/models/item'
require_relative '../../app/models/merchant'
require_relative '../../app/models/invoice'
require_relative '../../app/models/invoice_item'
require_relative '../../app/models/transaction'


namespace :import do |import|
  desc 'Import customers'
  task :import_customers => :environment do
    ActiveRecord::Base.connection.execute(Customer.copy_from './app/data/customers.csv')
  end

  desc 'Import merchants'
  task :import_merchants => :environment do
    ActiveRecord::Base.connection.execute(Merchant.copy_from './app/data/merchants.csv')
  end

  desc 'Import items'
  task :import_items => :environment do
    ActiveRecord::Base.connection.execute(Item.copy_from './app/data/items.csv')
  end


  desc 'Import invoices'
  task :import_invoices => :environment do
    ActiveRecord::Base.connection.execute(Invoice.copy_from './app/data/invoices.csv')
  end

  desc 'Import invoice_items'
  task :import_invoice_items => :environment do
    ActiveRecord::Base.connection.execute(InvoiceItem.copy_from './app/data/invoice_items.csv')
  end

  desc 'Import transactions'
  task :import_transactions => :environment do
    ActiveRecord::Base.connection.execute(Transaction.copy_from './app/data/transactions.csv')
  end

  desc 'All'
  task :all do
    import.tasks.each do |task|
      Rake::Task[task].invoke
    end
  end
end
