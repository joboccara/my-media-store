require 'date'

class ProductsController < ApplicationController
  def index
    items =
      if params[:month].present?
        month_number = Date::MONTHNAMES.index(params[:month].capitalize)
        month_number_string = "%02d" % month_number
        Item.where("strftime('%m', created_at) = ?", month_number_string)
      else
        Item.all
      end
    @products = items.map {|item| item.attributes.to_h.merge(price: price(item)) }
  end

  private

  def price(product)
    price =
      case product.kind
      when 'book'
        book_price
      when 'image'
        image_price
      when 'video'
        video_price
      else
        raise NotImplementedError, 'unknown product kind'
      end
    apply_premium_price(price, product)
  end

  def book_price
    ENV['BOOK_PURCHASE_PRICE'].to_f * 1.25
  end

  def image_price
    7
  end

  def video_price
    Time.now.hour.between?(5, 22) ? 15 : 9
  end

  def apply_premium_price(price, product)
    return price unless product.kind.in? %w[book video]
    return price unless product.title.downcase.include? 'premium'
    price * 1.05
  end
end
