class DownloadsController < ApplicationController
  def index
    downloaded_items = UserItem.includes(:item).where(user: params[:user_id]).map(&:item)
    downloaded_items_by_kind = downloaded_items.group_by{|item| item.kind + 's'}
    render json: downloaded_items_by_kind
  end

  def create
    UserItem.create(user_id: params[:user_id], item_id: params[:item_id])
  end
end
