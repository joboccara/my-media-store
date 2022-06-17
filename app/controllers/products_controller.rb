require 'date'

class ProductsController < ApplicationController
  def index
    pricer = Pricer.new
    items =
      if params[:month].present?
        month_number = Date::MONTHNAMES.index(params[:month].capitalize)
        month_number_string = "%02d" % month_number
        Product.where("strftime('%m', created_at) = ?", month_number_string)
      else
        Product.all
      end
    @products = items.map {|item| { product: item, kind: item.kind, price: pricer.price(item) } }
  end
end
