json.array! @products do |product|
  json.id product.id
  json.kind product.kind
  json.title product.title
  json.content product.content
end