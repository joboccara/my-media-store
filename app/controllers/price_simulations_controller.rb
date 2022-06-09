class PriceSimulationsController < ApplicationController
  def compute
    product_attributes = {}
    params.each { |key, value| product_attributes[key.to_sym] = product_attribute(key, value) }

    price_calculator = PriceCalculator.new(params[:kind])
    is_valid, error_message = validate_input(price_calculator, product_attributes)
    if is_valid
      render json: { price: price_calculator.compute(product_attributes) }
    else
      render json: { error: error_message }, status: :bad_request
    end
  end

  private

  def validate_input(price_calculator, product)
    missing_attributes = price_calculator.expected_attributes - product.keys
    return missing_attributes.empty? ?
      [true, nil] :
      [false, "missing parameters for pricing #{product[:kind]}s: #{missing_attributes.sort.join(', ')}"]
  end

  def product_attribute(key, value)
    case key
    when 'purchase_price' then value.to_f
    when 'is_hot' then value == 'true'
    when 'width' then value.to_i
    when 'height' then value.to_i
    when 'duration' then value.to_i
    else value
    end
  end
end