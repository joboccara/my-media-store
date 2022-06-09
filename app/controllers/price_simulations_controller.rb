class PriceSimulationsController < ApplicationController
  def compute
    begin
      price_calculator = PriceCalculator.new(params[:kind])
    rescue PriceCalculator::UnknownKindError => e
      return render json: { error: e.message }, status: :bad_request
    end

    product_attributes, error_message = parse_inputs(price_calculator, params)
    if error_message
      render json: { error: error_message }, status: :bad_request
    else
      render json: { price: price_calculator.compute(product_attributes) }
    end
  end

  private

  def parse_inputs(price_calculator, params)
    missing_attributes = price_calculator.expected_attributes - params.keys.map(&:to_sym)
    if missing_attributes.any?
      return [nil, "missing parameters for pricing #{params[:kind]}s: #{missing_attributes.sort.join(', ')}"]
    end

    product_attributes = {}
    params.each { |key, value| product_attributes[key.to_sym] = price_calculator.parse_attribute(key, value) }
    [product_attributes, nil]
  end
end