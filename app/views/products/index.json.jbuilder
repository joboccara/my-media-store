@products.group_by { |product| product[:kind] }.each do |kind, products|
  json.set!(kind + 's') do
    json.array! products, partial: '/products/product', as: :product
  end
end
