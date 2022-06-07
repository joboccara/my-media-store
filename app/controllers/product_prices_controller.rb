class ProductPricesController < ApplicationController
  IMAGE_FIXED_PRICE = 7
  def show
    product = Item.find(params[:id])
    price = case product.kind
    when 'book' then ENV['BOOK_PURCHASE_PRICE'].to_i * 1.25
    when 'image' then IMAGE_FIXED_PRICE
    when 'video' then (5 <= Time.now.hour && Time.now.hour < 22) ? 15 : 9
    end
    render json: price
  end
end
