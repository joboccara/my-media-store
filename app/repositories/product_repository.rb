class ProductRepository
  # @param title [String]
  # @param content [String]
  # @param category [String]
  # @param page_count [Integer]
  # @return [BookDto]
  def create_book(title:, content:, category:, page_count:)
    product = Item.create(kind: 'book', title: title, content: content, category: category)
    details = BookDetail.create(item: product, page_count: page_count)
    build_book_dto(product, details)
  end

  # @param title [String]
  # @param content [String]
  # @param category [String]
  # @param width [Integer]
  # @param height [Integer]
  # @return [ImageDto]
  def create_image(title:, content:, category:, width:, height:)
    product = Item.create(kind: 'image', title: title, content: content, category: category)
    details = ImageDetail.create(item: product, width: width, height: height)
    build_image_dto(product, details)
  end

  # @param title [String]
  # @param content [String]
  # @param category [String]
  # @param duration [Integer]
  # @return [VideoDto]
  def create_video(title:, content:, category:, duration:)
    product = Item.create(kind: 'video', title: title, content: content, category: category)
    details = VideoDetail.create(item: product, duration: duration)
    build_video_dto(product, details)
  end

  # Repository only return DTO, models are private entities to access data, not accessible from services & controllers
  # Business logic is not aware of how we store products (product & details)
  # @param id [Integer]
  # @return [BookDto, ImageDto, VideoDto]
  def get_product(id)
    product = Item.find(id)
    raise "Product not found #{id}" if product.nil?
    book_details = hash_by(product.kind == 'book' ? BookDetail.where(item: product) : [], :item_id)
    image_details = hash_by(product.kind == 'image' ? ImageDetail.where(item: product) : [], :item_id)
    video_details = hash_by(product.kind == 'video' ? VideoDetail.where(item: product) : [], :item_id)
    build_product_dto(product, book_details, image_details, video_details)
  end

  # @param category [String]
  # @return [[BookDto, ImageDto, VideoDto][]]
  def get_product_with_category(category)
    # other option: ActiveRecord::Associations::Preloader (https://thepaulo.medium.com/eager-loading-polymorphic-associations-in-ruby-on-rails-155a356c39d7)
    products = Item.where(category: category)
    grouped_products = products.group_by(&:kind)
    book_details = hash_by(BookDetail.where(item: grouped_products['book']), :item_id)
    image_details = hash_by(ImageDetail.where(item: grouped_products['image']), :item_id)
    video_details = hash_by(VideoDetail.where(item: grouped_products['video']), :item_id)
    products.map { |product| build_product_dto(product, book_details, image_details, video_details) }
  end

  # @param now [Time]
  # @return [BookDto[]]
  def books_of_week(now)
    books = Item.where(kind: 'book') # TODO: better filtering ^^
    book_details = hash_by(BookDetail.where(item: books), :item_id)
    books.map { |book| build_product_dto(book, book_details, {}, {}) }
  end

  private

  def hash_by(array, attr)
    Hash[array.collect { |value| [value[attr], value] }]
  end

  # @param product [Item]
  # @param book_details [{item_id: BookDetail}]
  # @param image_details [{item_id: ImageDetail}]
  # @param video_details [{item_id: VideoDetail}]
  # @return [BookDto, ImageDto, VideoDto]
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

  # @param product [Item]
  # @param details [BookDetail]
  # @return [BookDto]
  def build_book_dto(product, details)
    BookDto.new(product.id, product.kind, product.title, product.category, product.content, details.page_count)
  end

  # @param product [Item]
  # @param details [ImageDetail]
  # @return [ImageDto]
  def build_image_dto(product, details)
    ImageDto.new(product.id, product.kind, product.title, product.category, product.content, details.width, details.height)
  end

  # @param product [Item]
  # @param details [VideoDetail]
  # @return [VideoDto]
  def build_video_dto(product, details)
    VideoDto.new(product.id, product.kind, product.title, product.category, product.content, details.duration)
  end
end
