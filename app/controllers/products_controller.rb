class ProductsController < ApplicationController
  def index
    render json: ProductCatalog.new.call
  end
end
