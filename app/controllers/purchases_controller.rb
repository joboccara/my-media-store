class PurchasesController < ApplicationController
  def index
    render json: Invoice.where(user_id: params[:user_id])
  end

  def create
    product_repository = ProductRepository.new
    product = product_repository.get_product(params[:product_id])
    Invoice.create!(user_id: params[:user_id], title: product[:title])
  end
end
