class ProductPricesController < ApplicationController
  def show
    # FIXME at iteration 1
    puts "Compute price for product #{params[:id]}"
    render json: 0
  end
end
