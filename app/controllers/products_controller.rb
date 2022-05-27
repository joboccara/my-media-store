class ProductsController < ApplicationController
  def show
    products = ProductRepository.new
    product = products.get_product(params[:id])
    render json: product
  end
end
