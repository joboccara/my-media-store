class DownloadsController < ApplicationController
  def index
    downloaded_products = Download.includes(:item).where(user: params[:user_id]).map(&:item)
    downloaded_products_by_kind = downloaded_products.group_by { |product| product.kind }
    render json: downloaded_products_by_kind
  end

  def create
    head :bad_request if Download.where(user: params[:user_id], item: params[:item_id]).any?

    Download.create(user_id: params[:user_id], item_id: params[:item_id])
  end
end
