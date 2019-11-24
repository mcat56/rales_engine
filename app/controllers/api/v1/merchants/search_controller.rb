class Api::V1::Merchants::SearchController < ApplicationController

  def show
    merchant = Merchant.where(merchant_params).first
    serialized = MerchantSerializer.new(merchant)
    render json: serialized
  end

  def index
    merchants = Merchant.having(merchant_params).group(:id).order(:id)
    serialized = MerchantSerializer.new(merchants)
    render json: serialized
  end

  def random
    merchant = Merchant.order('RANDOM()').first
    serialized = MerchantSerializer.new(merchant)
    render json: serialized
  end

  def top_merchants
    top_merchants = Merchant.top_merchants(params[:quantity].to_i)
    serialized = MerchantSerializer.new(top_merchants)
    render json: serialized
  end

  def revenue_by_date
    revenue = Merchant.revenue_by_date(params[:date])
    revenue_hash = { data: { attributes: { total_revenue: to_currency(revenue)} } }
    render json: revenue_hash
  end

  def favorite_customer
    merchant = Merchant.find(params[:id])
    fav_customer = merchant.favorite_customer
    serialized = CustomerSerializer.new(fav_customer)
    render json: serialized
  end

  def customers_with_pending_invoices
    merchant = Merchant.find(params[:id])
    customers = merchant.customers_with_pending_invoices
    serialized = CustomerSerializer.new(customers)
    render json: serialized
  end

  private

  def merchant_params
    if params['name']
      params['name'].gsub(/'/, '%27')
    end
    params.permit(:id, :name, :updated_at, :created_at)
  end

  def to_currency(revenue)
    ('%.2f' % revenue)
  end

end
