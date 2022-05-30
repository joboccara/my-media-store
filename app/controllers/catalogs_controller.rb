class CatalogsController < ApplicationController
  # controller role is only to convert http request to domain and domain response to http one, nothing more
  def show
    pricer = Pricer.new
    products = ProductRepository.new.get_product_with_category(params[:id])
    @priced_products = products.map { |product| { product: product, price: pricer.get_price(product) } }
    # @priced_products is handled by show.json.jbuilder, serialization is independent from DTO
  end
end
