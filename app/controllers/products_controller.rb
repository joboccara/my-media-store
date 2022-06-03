class ProductsController < ApplicationController
  def show
    @product = ProductRepository.new.get_product(params[:id])
  end

  def index
    @products = ProductRepository.new.get_all_products
  end
end
