class PriceSimulationsController < ApplicationController
  def compute
    render json: { price: 0 }
  end
end
