# frozen_string_literal: true
module Purchases
  class Repository
    class << self
      def for_user(user_id)
        ::Purchase.where(user_id: user_id).map { |p| Purchase.new(p.title, p.product.id, p.price)}
      end
    end

    class Purchase
      attr_accessor :title, :product_id, :price

      def initialize(title, product_id, price)
        @price = price
        @product_id = product_id
        @title = title
      end
    end
  end
end