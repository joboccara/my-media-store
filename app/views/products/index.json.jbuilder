@products.group_by { |product| product[:kind] + 's' }.each do |kind, products|
  json.set!(kind) do
    json.array! products do |product|
      json.partial! '/products/product', product: product
    end
  end
end
