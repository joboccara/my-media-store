class ProductRepository
  def get_product(id)
    item = Item.find(id)
    raise "Product not found #{id}" if item.nil?
    book_details = hash_by(item.kind == 'book' ? BookDetail.where(item: item) : [], :item_id)
    image_details = hash_by(item.kind == 'image' ? ImageDetail.where(item: item) : [], :item_id)
    video_details = hash_by(item.kind == 'video' ? VideoDetail.where(item: item) : [], :item_id)
    build_product_dto_from_hashes(item, book_details, image_details, video_details)
  end

  def get_product_with_category(category)
    # other option: ActiveRecord::Associations::Preloader (https://thepaulo.medium.com/eager-loading-polymorphic-associations-in-ruby-on-rails-155a356c39d7)
    items = Item.where(category: category)
    grouped_items = items.group_by(&:kind)
    book_details = hash_by(BookDetail.where(item: grouped_items['book']), :item_id)
    image_details = hash_by(ImageDetail.where(item: grouped_items['image']), :item_id)
    video_details = hash_by(VideoDetail.where(item: grouped_items['video']), :item_id)
    items.map { |item| build_product_dto_from_hashes(item, book_details, image_details, video_details) }
  end

  def create_book(title:, content:, category:, page_count:)
    item = Item.create(kind: 'book', title: title, content: content, category: category)
    details = BookDetail.create(item: item, page_count: page_count)
    build_product_dto(item, build_book_dto(details))
  end

  def create_image(title:, content:, category:, width:, height:)
    item = Item.create(kind: 'image', title: title, content: content, category: category)
    details = ImageDetail.create(item: item, width: width, height: height)
    build_product_dto(item, build_image_dto(details))
  end

  def create_video(title:, content:, category:, duration:)
    item = Item.create(kind: 'video', title: title, content: content, category: category)
    details = VideoDetail.create(item: item, duration: duration)
    build_product_dto(item, build_video_dto(details))
  end

  private

  def hash_by(array, attr)
    Hash[array.collect { |item| [item[attr], item] }]
  end

  def build_product_dto_from_hashes(item, book_details, image_details, video_details)
    details = if item.kind == 'book'
                build_book_dto(book_details[item.id] || (raise "Missing details for book #{item.id}"))
              elsif item.kind == 'image'
                build_image_dto(image_details[item.id] || (raise "Missing details for image #{item.id}"))
              elsif item.kind == 'video'
                build_video_dto(video_details[item.id] || (raise "Missing details for video #{item.id}"))
              else
                raise "Unknown item kind #{item.kind.inspect}"
              end
    build_product_dto(item, details)
  end

  def build_product_dto(item, details_dto)
    {
      id: item.id,
      kind: item.kind,
      title: item.title,
      category: item.category,
      content: item.content
    }.merge(details_dto)
  end

  def build_book_dto(details)
    {
      page_count: details.page_count
    }
  end

  def build_image_dto(details)
    {
      width: details.width,
      height: details.height
    }
  end

  def build_video_dto(details)
    {
      duration: details.duration
    }
  end
end
