class ProductsController < ApplicationController
  def index
    render json: ProductCatalog.new.all
  end

  def show
    ProductCatalog.new.find(params[:item_id])
  end
end
