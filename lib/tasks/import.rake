require 'csv'

desc 'Import customers'

namespace :import do |import|
  task :import_customers => :environment do
    require "pry"; binding.pry
    ActiveRecord::Base.connection.execute "COPY customers FROM '../app/data/customers.csv' DELIMITER ',' CSV;"
  end

  desc 'Import merchants'
  task :import_merchants => :environment do
    ActiveRecord::Base.connection.execute "COPY merchants FROM '../app/data/merchants.csv' DELIMITER ',' CSV;"
  end

  desc 'Import items'
  task :import_items => :environment do
    ActiveRecord::Base.connection.execute "COPY items FROM '../app/data/items.csv' DELIMITER ',' CSV;"
  end


  desc 'Import invoices'
  task :import_invoices => :environment do
    ActiveRecord::Base.connection.execute "COPY invoices FROM '../app/data/invoices.csv' DELIMITER ',' CSV;"
  end

  desc 'Import invoice_items'
  task :import_invoice_items => :environment do
    ActiveRecord::Base.connection.execute "COPY invoice_items FROM '../app/data/invoice_items.csv' DELIMITER ',' CSV;"
  end

  desc 'Import transactions'
  task :import_transactions => :environment do
    ActiveRecord::Base.connection.execute "COPY transactions FROM '../app/data/transactions.csv' DELIMITER ',' CSV;"
  end

  desc 'All'
  task :all do
    import.tasks.each do |task|
      Rake::Task[task].invoke
    end
  end
end
