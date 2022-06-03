class ProductsController < ApplicationController
  def show
    ProductPricer.new.compute(params[:product_category], params[:pricing_attributes])
  end
end
