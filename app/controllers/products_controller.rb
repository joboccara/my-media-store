class ProductsController < ApplicationController
  def show
    @product = ProductRepository.new.get_product(params[:id])
    @price = Pricer.new.get_price(@product)
  end
end
