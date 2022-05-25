class DownloadsController < ApplicationController
  def index
    @downloaded_items = Download.includes(:item).where(user: params[:user_id]).map(&:item)
  end

  def create
    head :bad_request if Download.where(user: params[:user_id], item: params[:item_id]).any?

    Download.create(user_id: params[:user_id], item_id: params[:item_id])
  end
end
