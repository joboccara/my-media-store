# frozen_string_literal: true
class Products::Catalog
  def initialize(pricer = Pricer.new)
    @pricer = pricer
  end

  def all
    products_with_price(::Product.all)
  end

  def for_period(from:, to:)
    products_with_price(
      ::Product
        .where('created_at >= ?', from)
        .where('created_at < ?', to)
    )
  end

  private

  def products_with_price(products)
    products.map {|product| Products::Product.from_product(product).with_price(@pricer.price(product)) }
  end
end
