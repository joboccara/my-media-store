class ProductRepository
  def get_product(id)
    build_products([Item.find(id)]).first
  end

  def get_product_of_month(month)
    month_number = Date::MONTHNAMES.index(month)
    month_number_string = "%02d" % month_number
    build_products(Item.where("strftime('%m', created_at) = ?", month_number_string))
  end

  def get_all_products
    build_products(Item.all)
  end

  def create_book(title:, content: 'content', isbn:, purchase_price:, is_hot:, created_at: nil)
    item = Item.create!(kind: 'book', title: title, content: content, created_at: created_at)
    book_details = BookDetail.create!(item: item, isbn: isbn, purchase_price: purchase_price, is_hot: is_hot)
    item_dto(item).merge(book_details_dto(book_details))
  end

  def create_image(title:, content: 'content', width:, height:, source:, format:, created_at: nil)
    item = Item.create!(kind: 'image', title: title, content: content, created_at: created_at)
    image_details = ImageDetail.create!(item: item, width: width, height: height, source: source, format: format)
    item_dto(item).merge(image_details_dto(image_details))
  end

  def create_video(title:, content: 'content', duration:, quality:, created_at: nil)
    item = Item.create!(kind: 'video', title: title, content: content, created_at: created_at)
    video_details = VideoDetail.create!(item: item, duration: duration, quality: quality)
    item_dto(item).merge(video_details_dto(video_details))
  end

  def update_book(id:, title:, content:, isbn:, purchase_price:, is_hot:)
    Item.where(id: id).update_all(title: title, content: content)
    BookDetail.where(item_id: id).update_all(isbn: isbn, purchase_price: purchase_price, is_hot: is_hot)
  end

  private

  def build_products(items)
    book_details = BookDetail.where(item: items).to_a
    image_details = ImageDetail.where(item: items).to_a
    video_details = VideoDetail.where(item: items).to_a
    items.map do |item|
      belongs_to_item = ->(detail) { detail.item_id == item.id }
      details_dto = case item.kind
      when 'book' then book_details_dto(book_details.find(&belongs_to_item))
      when 'image' then image_details_dto(image_details.find(&belongs_to_item))
      when 'video' then video_details_dto(video_details.find(&belongs_to_item))
      else raise "Unknown item kind #{item.kind.inspect}"
      end
      item_dto(item).merge(details_dto)
    end
  end

  def item_dto(item)
    {
      id: item.id,
      title: item.title,
      content: item.content,
      kind: item.kind
    }
  end

  def book_details_dto(book_details)
    {
      isbn: book_details.isbn,
      purchase_price: book_details.purchase_price,
      is_hot: book_details.is_hot
    }
  end

  def image_details_dto(image_details)
    {
      width: image_details.width,
      height: image_details.height,
      source: image_details.source,
      format: image_details.format
    }
  end

  def video_details_dto(video_details)
    {
      duration: video_details.duration,
      quality: video_details.quality
    }
  end
end
