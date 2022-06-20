# frozen_string_literal: true
module Purchases
  class Create
    class << self
      def call(user_id, product_id)
        product = Product.find(product_id)
        user = User.find(user_id)
        Purchase.create!(user: user, product_id: product_id, title: product.title, price: Pricing::Pricer.new.price(product))
        Download.create!(user: user, product: product)
      end
    end
  end
end
