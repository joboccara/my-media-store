class ProductRepository
  def get_product(id)
    build_products([Item.find(id)]).first
end

  def get_product_with_category(category)
    build_products(Item.where(category: category))
  end

  def get_product_of_month(month)
    month_number = Date::MONTHNAMES.index(month)
    month_number_string = "%02d" % month_number
    build_products(Item.where("strftime('%m', created_at) = ?", month_number_string))
end

  def get_all_products
    build_products(Item.all)
  end

  def create_book(title:, content:, category: nil, page_count: nil, created_at: nil)
    item = Item.create!(kind: 'book', title: title, content: content, category: category, created_at: created_at)
    book_details = BookDetail.create!(item: item, page_count: page_count)
    item_dto(item).merge(book_details_model_dto(book_details))
  end

  def update_book(item_id:, **new_attributes)
    item_attributes, book_details_attributes = partition_book_attributes(new_attributes)
    Item.update(item_id, item_attributes) if item_attributes.present?
    BookDetail.update(BookDetail.find_by(item_id: item_id).id, book_details_attributes) if book_details_attributes.present?
  end

  def create_image(title:, content:, category: nil, width: nil, height: nil, created_at: nil)
    item = Item.create!(kind: 'image', title: title, content: content, category: category, created_at: created_at)
    if ENV['IMAGES_FROM_EXTERNAL_SERVICE']
      external_id = ImageExternalService.upload_image_details(width: width, height: height)
      image_external_details = ImageExternalDetail.create!(item: item, external_id: external_id)
    else
      image_details = ImageDetail.create!(item: item, width: width, height: height)
    end
    item_dto(item).merge(image_details_dto(width: width, height: height))
  end

  def update_image(item_id:, **new_attributes)
    item_attributes, image_details_attributes = partition_image_attributes(new_attributes)
    Item.update(item_id, item_attributes) if item_attributes.present?
    ImageDetail.update(ImageDetail.find_by(item_id: item_id).id, image_details_attributes) if image_details_attributes.present?
  end

  def create_video(title:, content:, category:, duration:, created_at: nil)
    item = Item.create!(kind: 'video', title: title, content: content, category: category, created_at: created_at)
    video_details = VideoDetail.create!(item: item, duration: duration)
    item_dto(item).merge(video_details_model_dto(video_details))
  end

  def update_video(item_id:, **new_attributes)
    item_attributes, video_details_attributes = partition_video_attributes(new_attributes)
    Item.update(item_id, item_attributes) if item_attributes.present?
    VideoDetail.update(VideoDetail.find_by(item_id: item_id).id, video_details_attributes) if video_details_attributes.present?
  end

  private

  def build_products(items)
    book_details = BookDetail.where(item: items).to_a
    if ENV['IMAGES_FROM_EXTERNAL_SERVICE']
      image_external_details = ImageExternalDetail.where(item: items).to_a
    else
      image_details = ImageDetail.where(item: items).to_a
    end
    video_details = VideoDetail.where(item: items).to_a
    items.map do |item|
      belongs_to_item = ->(detail) { detail.item_id == item.id }
      case item.kind
      when 'book' then details_dto = book_details_model_dto(book_details.find(&belongs_to_item))
      when 'image'
        details_dto = if ENV['IMAGES_FROM_EXTERNAL_SERVICE']
          image_external_details_dto(image_external_details.find(&belongs_to_item))
        else
          image_details_model_dto(image_details.find(&belongs_to_item))
        end
      when 'video' then details_dto = video_details_model_dto(video_details.find(&belongs_to_item))
      end
      item_dto(item).merge(details_dto)
    end
  end

  def item_dto(item)
    {
      id: item.id,
      title: item.title,
      content: item.content,
      category: item.category,
      kind: item.kind
    }
  end

  def book_details_model_dto(book_details)
    {
      page_count: book_details.page_count
    }
  end

  def image_details_model_dto(image_details)
    image_details_dto(width: image_details.width, height: image_details.height)
  end

  def image_details_dto(width:, height:)
    {
      width: width,
      height: height
    }
  end

  def image_external_details_dto(image_external_details)
    details = ImageExternalService.get_image_details(image_external_details.external_id)
    {
      width: details[:width],
      height: details[:height]
    }
  end

  def video_details_model_dto(video_details)
    {
      duration: video_details.duration
    }
  end

  def partition_book_attributes(attributes)
    partition_attributes attributes, Item, BookDetail
  end


  def partition_image_attributes(attributes)
    partition_attributes attributes, Item, ImageDetail
  end

  def partition_video_attributes(attributes)
    partition_attributes attributes, Item, VideoDetail
  end

  def partition_attributes(attributes, table_1, table_2)
    table_1_columns = attributes.keys & table_1.column_names.map(&:to_sym)
    table_2_columns = attributes.keys & table_2.column_names.map(&:to_sym)
    unknown_columns = attributes.keys - (table_1_columns + table_2_columns)
    raise "Unknown attributes: #{unknown_columns}" if unknown_columns.any?
    [
      attributes.slice(*table_1_columns),
      attributes.slice(*table_2_columns)
    ]
  end
end