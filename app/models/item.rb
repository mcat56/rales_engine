class Item < ApplicationRecord
  validates_presence_of :name, :description, :unit_price
  belongs_to :merchant

  require 'csv'
  require 'activerecord-import/base'
  require 'activerecord-import/active_record/adapters/postgresql_adapter'

  def self.import(file)
    items = []
    CSV.foreach('./data/items.csv', headers: true ) do |row|
      items << Item.new(row.to_h)
    end
    Item.import items, recursive: true
  end
end
