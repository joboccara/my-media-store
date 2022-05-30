class ProductsController < ApplicationController
  def show
    @product = ProductRepository.new.get_product(params[:id])
    @price = Pricer.new.get_price(@product)
  end

  def simulate
    pricer = Pricer.new
    if params[:kind] == 'book'
      render json: { price: pricer.price_book(params[:page_count].to_i) }
    elsif params[:kind] == 'image'
      render json: { price: pricer.price_image(params[:width].to_i, params[:height].to_i) }
    elsif params[:kind] == 'video'
      render json: { price: pricer.price_video(params[:duration].to_i) }
    else
      render json: { error: "Can't simulate price for '#{params[:kind]}'" }, status: 400
    end
  end
end
