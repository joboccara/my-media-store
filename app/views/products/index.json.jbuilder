@products.group_by { |product| product.kind.downcase + 's' }.each do |kind, products|
  json.set! kind do
    json.array! products, partial: 'product', as: :product
  end
end
