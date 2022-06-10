class PurchasesController < ApplicationController
  def index
    products = ProductRepository.new
    invoices = Invoice.where(user_id: params[:user_id])
    payload = invoices.map do |invoice|
      product = products.get_product(invoice.item_id)
      price = PriceCalculator.new(product[:kind]).compute(product)
      { title: invoice.title, item_id: invoice.item_id, price: price }
    end
    render json: payload
  end

  def create
    product_repository = ProductRepository.new
    product = product_repository.get_product(params[:product_id])
    Download.create(user_id: params[:user_id], item_id: params[:product_id])
    Invoice.create!(user_id: params[:user_id], title: product[:title], item_id: params[:product_id])
  end
end
