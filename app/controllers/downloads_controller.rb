class DownloadsController < ApplicationController
  def index
    downloaded_products = Download.includes(:product).where(user: params[:user_id]).map(&:product)
    downloaded_products_by_kind = downloaded_products.group_by { |product| product.kind.downcase + 's' }
    render json: downloaded_products_by_kind
  end

  def create
    head :bad_request if Download.where(user: params[:user_id], product: params[:product_id]).any?

    Download.create!(user_id: params[:user_id], product_id: params[:product_id])
  end
end
