class CatalogsController < ApplicationController
  def show
    render json: Item.where(category: params[:id])
  end
end
