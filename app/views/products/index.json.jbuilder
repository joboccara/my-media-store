@products.group_by { |product| product.kind + 's' }.each do |kind, products|
  json.set! kind, products
end
