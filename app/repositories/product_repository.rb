class ProductRepository
  def get_product(id)
    item = Item.find(id)
    dto =
      {
        title: item.title,
        kind: item.kind,
        content: item.content
      }
    details = if item.kind == 'book'
                get_book_details(item)
              elsif item.kind == 'image'
                get_image_details(item)
              elsif item.kind == 'video'
                get_video_details(item)
              else
                raise "Unknown item kind #{item.kind}"
              end
    dto.merge(details)
  end

  private

  def get_book_details(item)
    details = BookDetail.find_by(item: item)
    {
      page_count: details.page_count
    }
  end

  def get_image_details(item)
    details = ImageDetail.find_by(item: item)
    {
      width: details.width,
      height: details.height
    }
  end

  def get_video_details(item)
    details = VideoDetail.find_by(item: item)
    {
      duration: details.duration
    }
  end
end
