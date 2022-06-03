class ProductsController < ApplicationController
  def show
    @product = ProductRepository.new.get_product(params[:id])
  end

  def index
    if (params[:month].present?)
      @products = ProductRepository.new.get_product_of_month(params[:month].capitalize)
    else
      @products = Item.all
    end
  end
end
