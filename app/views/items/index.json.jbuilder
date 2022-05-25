items_by_kind = @items.group_by{|item| item.kind + 's'}

items_by_kind.map do |kind, items|
  json.set! kind do
    json.array! items do |item|
      json.title item.title
      json.content item.content
      json.price item.price
    end
  end
end