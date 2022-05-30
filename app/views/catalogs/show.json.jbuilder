json.array! @priced_products do |priced_product|
  json.partial! '/products/product', product: priced_product[:product]
  json.price priced_product[:price]
end
