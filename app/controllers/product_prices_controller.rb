# controllers should only be an adapter between HTTP and the domain, ie: extract/parse params, then serialize response
class ProductPricesController < ApplicationController
  def show
    id = params[:id].to_i
    now = Time.now

    product = ProductRepository.new.get_product(id)
    catalog = ProductCatalog.new(Rails.configuration.product_catalog_path)
    price = ProductPricer.new(catalog, now).compute(product)

    render json: price
  end
end
