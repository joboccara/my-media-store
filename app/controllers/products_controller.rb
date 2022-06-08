require 'date'

class ProductsController < ApplicationController
  def index
    if params[:month].present?
      month_number = Date::MONTHNAMES.index(params[:month].capitalize)
      month_number_string = "%02d" % month_number
      @products = Item.where("strftime('%m', created_at) = ?", month_number_string)
    else
      @products = Item.all
    end
  end
end
