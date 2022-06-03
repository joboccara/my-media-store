# frozen_string_literal: true
class ProductCatalog
  def all
    product_pricer = ProductPricer.new
    Item.all.map do |item|
      {
        title: item.title,
        content: item.content,
        price: product_pricer.compute(item.kind, { title: item.title }),
        category: item.kind
      }
    end.group_by{|item| item[:category].pluralize }
  end

  def find(product_id)
    Item.find(product_id)
  end
end
