class ProductsController < ApplicationController
  def show
    render json: ProductRepository.new.get_product(params[:id])
  end
end
