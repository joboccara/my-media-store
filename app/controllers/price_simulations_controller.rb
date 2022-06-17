class PriceSimulationsController < ApplicationController
  def compute
    kind = params[:kind]&.to_s
    now = Time.now

    catalog = ProductCatalog.new(Rails.configuration.product_catalog_path)
    calculator = PriceCalculator.default(catalog)

    calculator.price(params.to_unsafe_hash, now).fold(
      if_pending: proc { render json: { error: "cannot price product #{kind.nil? ? 'with no kind' : "of kind #{kind}"}" }, status: :bad_request },
      if_failure: proc { |err| render json: { error: format_error(err, kind) }, status: :bad_request },
      if_success: proc { |price| render json: { price: price } }
    )
  end

  private

  # @param error [String, Parser::Error]
  # @param kind [String, nil]
  # @return [String]
  def format_error(error, kind)
    return error if error.is_a?(String)
    errors = error.is_a?(Parser::Error) ? error.flatten : [error]
    required_errors = errors.filter { |e| e.is_a?(Parser::RequiredError) }
    if required_errors.empty?
      error.message
    else
      "missing parameters#{kind.nil? ? '' : " for pricing #{kind}s"}: #{required_errors.map(&:path).sort.join(', ')}"
    end
  end
end
