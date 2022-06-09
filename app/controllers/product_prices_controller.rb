class ProductPricesController < ApplicationController
  def show
    products = ProductRepository.new
    product = products.get_product(params[:id])
    price = PriceCalculator.new(product[:kind]).compute(product)

    render json: price
  end
end
