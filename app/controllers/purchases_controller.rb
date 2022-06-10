class PurchasesController < ApplicationController
  def index
    render json: Invoice.where(user_id: params[:user_id])
  end

  def create
    product_repository = ProductRepository.new
    product = product_repository.get_product(params[:product_id])
    price = PriceCalculator.new(product[:kind]).compute(product)
    Download.create(user_id: params[:user_id], item_id: params[:product_id])
    Invoice.create!(user_id: params[:user_id], title: product[:title], price: price, item_id: params[:product_id])
  end
end
