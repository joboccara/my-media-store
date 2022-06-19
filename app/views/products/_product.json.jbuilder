json.title product.title
json.kind product.kind
json.content product.content
product.fold(
  book: proc { |b| json.partial! '/products/book_detail', details: b },
  image: proc { |i| json.partial! '/products/image_detail', details: i },
  video: proc { |v| json.partial! '/products/video_detail', details: v }
)
