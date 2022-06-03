class ProductsController < ApplicationController
  def index
    @products = Item.all
  end
end
