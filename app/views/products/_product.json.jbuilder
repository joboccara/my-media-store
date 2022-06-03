json.title product[:title]
json.kind product[:kind]
json.category product[:category]
if product[:kind] == 'book'
  json.partial! '/products/book_detail', details: product
elsif product[:kind] == 'image'
  json.partial! '/products/image_detail', details: product
elsif product[:kind] == 'video'
  json.partial! '/products/video_detail', details: product
else
  raise "Unknown item kind #{product.kind.inspect}"
end
