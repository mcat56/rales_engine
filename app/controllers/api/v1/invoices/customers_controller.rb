class Api::V1::Invoices::CustomersController < ApplicationController

  def show
    invoice = Invoice.find(params[:id])
    customer = invoice.customer
    serialized = CustomerSerializer.new(customer)

    render json: serialized
  end

end
