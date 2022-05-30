class ProductRepository
  # Repository only return DTO, models are private entities to access data, not accessible from services & controllers
  # Business logic is not aware of how we store products (product & details)
  def get_product(id)
    product = Item.find(id)
    raise "Product not found #{id}" if product.nil?
    book_details = hash_by(product.kind == 'book' ? BookDetail.where(item: product) : [], :item_id)
    image_details = hash_by(product.kind == 'image' ? ImageDetail.where(item: product) : [], :item_id)
    video_details = hash_by(product.kind == 'video' ? VideoDetail.where(item: product) : [], :item_id)
    build_product_dto(product, book_details, image_details, video_details)
  end

  def get_product_with_category(category)
    # other option: ActiveRecord::Associations::Preloader (https://thepaulo.medium.com/eager-loading-polymorphic-associations-in-ruby-on-rails-155a356c39d7)
    products = Item.where(category: category)
    grouped_products = products.group_by(&:kind)
    book_details = hash_by(BookDetail.where(item: grouped_products['book']), :item_id)
    image_details = hash_by(ImageDetail.where(item: grouped_products['image']), :item_id)
    video_details = hash_by(VideoDetail.where(item: grouped_products['video']), :item_id)
    products.map { |product| build_product_dto(product, book_details, image_details, video_details) }
  end

  def create_book(title:, content:, category:, page_count:)
    product = Item.create(kind: 'book', title: title, content: content, category: category)
    details = BookDetail.create(item: product, page_count: page_count)
    build_book_dto(product, details)
  end

  def create_image(title:, content:, category:, width:, height:)
    product = Item.create(kind: 'image', title: title, content: content, category: category)
    details = ImageDetail.create(item: product, width: width, height: height)
    build_image_dto(product, details)
  end

  def create_video(title:, content:, category:, duration:)
    product = Item.create(kind: 'video', title: title, content: content, category: category)
    details = VideoDetail.create(item: product, duration: duration)
    build_video_dto(product, details)
  end

  private

  def hash_by(array, attr)
    Hash[array.collect { |value| [value[attr], value] }]
  end

  def build_product_dto(product, book_details, image_details, video_details)
    if product.kind == 'book'
      build_book_dto(product, book_details[product.id] || (raise "Missing details for book #{product.id}"))
    elsif product.kind == 'image'
      build_image_dto(product, image_details[product.id] || (raise "Missing details for image #{product.id}"))
    elsif product.kind == 'video'
      build_video_dto(product, video_details[product.id] || (raise "Missing details for video #{product.id}"))
    else
      raise "Unknown product kind #{product.kind.inspect}"
    end
  end

  BookDto = Struct.new(:id, :kind, :title, :category, :content, :page_count)
  ImageDto = Struct.new(:id, :kind, :title, :category, :content, :width, :height)
  VideoDto = Struct.new(:id, :kind, :title, :category, :content, :duration)

  def build_book_dto(product, details)
    BookDto.new(product.id, product.kind, product.title, product.category, product.content, details.page_count)
  end

  def build_image_dto(product, details)
    ImageDto.new(product.id, product.kind, product.title, product.category, product.content, details.width, details.height)
  end

  def build_video_dto(product, details)
    VideoDto.new(product.id, product.kind, product.title, product.category, product.content, details.duration)
  end
end
