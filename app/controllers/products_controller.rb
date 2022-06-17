require 'date'

class ProductsController < ApplicationController
  def index
    @products =
      if params[:month].present?
        month_number = Date::MONTHNAMES.index(params[:month].capitalize) || 1
        from = Date.new(Time.now.year, month_number)
        Products::Catalog.new.for_period(from: from, to: from.at_end_of_month)
      else
        Products::Catalog.new.all
      end
  end
end
