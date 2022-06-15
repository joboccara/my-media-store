require 'date'

class ProductsController < ApplicationController
  def index
    if params[:month].present?
      month_number = Date::MONTHNAMES.index(params[:month].capitalize)
      month_number_string = "%02d" % month_number
      @products = Product.where("strftime('%m', created_at) = ?", month_number_string)
    else
      @products = Product.all
    end
  end
end
