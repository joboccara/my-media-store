json.title @item.title
json.kind @item.kind
if @item.kind == 'book'
  json.partial! 'book_details/book_details', details: @details
end
json.content @item.content