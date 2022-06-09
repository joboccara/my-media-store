class PriceSimulationsController < ApplicationController
  def compute
    product_attributes = {}
    params.each { |key, value| product_attributes[key.to_sym] = product_attribute(key, value) }
    price = PriceCalculator.new(params[:kind]).compute(product_attributes)
    render json: price
  end

  private

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