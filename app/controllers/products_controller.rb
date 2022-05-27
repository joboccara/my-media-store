class ProductsController < ApplicationController
  def show
    render json: Item.find(params[:id])
  end
end
