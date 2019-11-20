class TransactionSerializer
  include FastJsonapi::ObjectSerializer

  attributes :result

  attribute :last_four do |transaction|
    transaction.credit_card_number.to_s[-4..-1].to_i
  end

  belongs_to :invoice


end
