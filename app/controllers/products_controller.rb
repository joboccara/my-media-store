require 'date'

class ProductsController < ApplicationController
  def index
    month = params[:month]&.to_s

    product_repo = ProductRepository.new
    @products = month ? product_repo.get_month_products(month) : product_repo.get_products
  end
end
