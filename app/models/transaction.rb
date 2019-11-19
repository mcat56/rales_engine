class Transaction < ApplicationRecord
  validates_presence_of :credit_card_number, :result
  belongs_to :invoice

  require 'csv'
  require 'activerecord-import/base'
  require 'activerecord-import/active_record/adapters/postgresql_adapter'


  def self.import(file)
    transactions = []
    CSV.foreach('./data/transactions.csv', headers: true ) do |row|
      transactions << Transaction.new(row.to_h)
    end
    Transaction.import transactions, recursive: true
  end
end
