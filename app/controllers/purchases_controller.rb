class PurchasesController < ApplicationController
  def index
    render json: Invoice.where(user_id: params[:user_id])
  end

  def create
    user_id = params[:user_id]
    product_id = params[:product_id]

    product_repository = ProductRepository.new
    product = product_repository.get_product(product_id)
    price = PriceCalculator.new(product[:kind]).compute(product)
    Download.create!(user_id: user_id, item_id: product[:id])
    Invoice.create!(user_id: user_id, item_id: product[:id], title: product[:title], price: price)
  end
end
