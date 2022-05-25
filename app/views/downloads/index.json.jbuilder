downloaded_items_by_kind = @downloaded_items.group_by{|item| item.kind + 's'}

downloaded_items_by_kind.map do |kind, items|
  json.set! kind do
    json.array! items do |item|
      json.title item.title
      json.content item.content
    end
  end
end