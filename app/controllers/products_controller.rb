class ProductsController < ApplicationController
  def show
    @product = ProductRepository.new.get_product(params[:id])
  end
end
