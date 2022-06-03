@products.group_by{|product| product.kind + 's'}.each do |kind, products|
    json.set! kind, products.map do |product|
    json.id product.id
    json.kind product.kind
    json.title product.title
    json.content product.content
  end
end