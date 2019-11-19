class Merchant < ApplicationRecord
  validates_presence_of :name
  has_many :invoices
  has_many :items

  require 'csv'
  require 'activerecord-import/base'
  require 'activerecord-import/active_record/adapters/postgresql_adapter'

  def self.import(file)
    merchants = []
    CSV.foreach('./data/merchants.csv', headers: true ) do |row|
      merchants << Merchant.new(row.to_h)
    end
    Merchant.import merchants, recursive: true
  end

end
