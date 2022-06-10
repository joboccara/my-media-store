class ProductPricesController < ApplicationController
  def show
    # FIXME at iteration 1
    puts "Compute price for item #{params[:id]}"
    render json: 0
  end
end
