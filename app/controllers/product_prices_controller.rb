# controllers should only be an adapter between HTTP and the domain, ie: extract/parse params, then serialize response
class ProductPricesController < ApplicationController
  def show
    id = params[:id].to_i
    now = Time.now

    product = ProductRepository.new.get_product(id)
    catalog = ProductCatalog.new(Rails.configuration.product_catalog_path)
    calculator = PriceCalculator.default(catalog)

    calculator.price(product.to_h, now).fold(
      if_pending: proc { render json: { error: "cannot price product #{p[:kind].nil? ? 'with no kind' : "of kind #{p[:kind]}"}" }, status: :bad_request },
      if_failure: proc { |err| render json: { error: err }, status: :bad_request },
      if_success: proc { |price| render json: price }
    )
  end
end
