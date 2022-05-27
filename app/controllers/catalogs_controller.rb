class CatalogsController < ApplicationController
  def show
    @products = ProductRepository.new.get_product_with_category(params[:id])
  end
end
