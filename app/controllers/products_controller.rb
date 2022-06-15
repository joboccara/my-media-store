require 'date'

class ProductsController < ApplicationController
  def index
    month = params[:month]&.to_s

    product_repository = ProductRepository.new
    @products = month ? product_repository.get_month_products(month) : product_repository.get_products
  end
end
