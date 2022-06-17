class PriceSimulationsController < ApplicationController
  def compute
    render json: { price: Pricer.new.price(product) }
  end

  private

  def product
    case params[:kind].camelcase
    when 'Book'
      Book.new(params.permit(:title, :isbn, :purchase_price, :is_hot))
    when 'Image'
      Image.new(params.permit(:title, :width, :height, :source, :format))
    when 'Video'
      Video.new(params.permit(:title, :duration, :quality))
    else
      raise NotImplementedError, 'unknown product kind'
    end
  end
end
