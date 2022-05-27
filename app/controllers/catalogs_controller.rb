class CatalogsController < ApplicationController
  def show
    render json: ProductRepository.new.get_product_with_category(params[:id])
  end
end
