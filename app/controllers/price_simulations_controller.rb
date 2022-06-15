class PriceSimulationsController < ApplicationController
  def compute
    p = params.permit(:kind, :title, :isbn, :purchase_price, :is_hot, :width, :height, :source, :format, :duration, :quality).to_h
    now = Time.now

    catalog = ProductCatalog.new(Rails.configuration.product_catalog_path)
    PriceCalculator
      .default(catalog)
      .price(p, now)
      .fold(
        if_pending: proc { render json: { error: "cannot price product #{p[:kind].nil? ? 'with no kind' : "of kind #{p[:kind]}"}" }, status: :bad_request },
        if_failure: proc { |err| render json: { error: err }, status: :bad_request },
        if_success: proc { |price| render json: { price: price } }
      )
  end
end
