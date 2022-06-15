@products.group_by { |product| product.kind + 's' }.each do |kind, products|
  json.set! kind do
    json.array! products, partial: '/products/product', as: :product
  end
end
