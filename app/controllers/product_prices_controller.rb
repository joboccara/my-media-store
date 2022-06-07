class ProductPricesController < ApplicationController
  IMAGE_FIXED_PRICE = 7
  def show
    @product = Item.find(params[:id])
    render json: (@product.kind == 'book' ? ENV['BOOK_PURCHASE_PRICE'].to_i * 1.25 : IMAGE_FIXED_PRICE)
  end
end
