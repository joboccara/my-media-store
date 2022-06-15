# controllers should only be an adapter between HTTP and the domain, ie: extract/parse params, then serialize response
class ProductPricesController < ApplicationController
  def show
    id = params[:id].to_i
    book_purchase_price = ENV['BOOK_PURCHASE_PRICE'].to_f
    now = Time.now

    product = ProductRepository.new.get_product(id)
    price = ProductPricer.new(book_purchase_price, now).compute(product)

    render json: price
  end
end
