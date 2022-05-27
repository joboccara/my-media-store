class ProductRepository
  def get_product(id)
    item = Item.find(id)
    dto =
      {
        title: item.title,
        kind: item.kind,
        content: item.content
      }
    if item.kind == 'book'
      details = BookDetail.find_by(item: item)
      dto[:page_count] = details.page_count
      dto
    else
      dto
    end
  end
end
