class PurchasesController < ApplicationController
  def index
    # FIXME at iteration 6
    puts "Get user purchases #{params[:user_id]}"
    render json: [{title: 'book1', item_id: 0, price: 0}]
  end

  def create
    # FIXME at iteration 6
    puts "User #{params[:user_id]} purchase item #{params[:product_id]}"
  end
end
