class PurchasesController < ApplicationController
  def index
    render json: Purchases::Repository.for_user(params[:user_id])
  end

  def create
    params.permit(:user_id, :product_id)
    Purchases::Create.call(params[:user_id], params[:product_id])
    head :ok
  end
end
