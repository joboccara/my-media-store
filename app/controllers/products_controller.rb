class ProductsController < ApplicationController
  def show
    @item = Item.find(params[:id])
    if (@item.kind == 'book')
      @details = BookDetail.find_by(item: @item)
    end
  end
end
