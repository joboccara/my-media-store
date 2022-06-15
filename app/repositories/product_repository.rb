require 'date'

# repositories offer a business abstraction to access data, models should only be used inside them
class ProductRepository
  # @param id [Integer]
  # @return [BookDto, ImageDto, VideoDto]
  def get_product(id)
    product = Product.find(id)
    raise "Product #{id.inspect} not found" if product.nil?
    book_details = hash_by(product.kind == 'book' ? BookDetail.where(product: product).to_a : [], :product_id)
    image_details = hash_by(product.kind == 'image' ? ImageDetail.where(product: product).to_a : [], :product_id)
    video_details = hash_by(product.kind == 'video' ? VideoDetail.where(product: product).to_a : [], :product_id)
    build_product_dto(product, book_details, image_details, video_details)
  end

  # @return [Array<[BookDto, ImageDto, VideoDto]>]
  def get_products
    fetch_details(Product.all.to_a)
  end

  # @param month [String]
  # @return [Array<[BookDto, ImageDto, VideoDto]>]
  def get_month_products(month)
    month_number = Date::MONTHNAMES.index(month.capitalize)
    month_number_string = "%02d" % month_number
    fetch_details(Product.where("strftime('%m', created_at) = ?", month_number_string).to_a)
  end

  # @param title [String]
  # @param content [String]
  # @param isbn [String]
  # @param purchase_price [Float]
  # @param is_hot [Boolean]
  # @return [BookDto]
  def create_book(title:, content:, isbn:, purchase_price:, is_hot:)
    product = Product.create!(kind: 'book', title: title, content: content)
    details = BookDetail.create!(product: product, isbn: isbn, purchase_price: purchase_price, is_hot: is_hot)
    build_book_dto(product, details)
  end

  # @param title [String]
  # @param content [String]
  # @param width [Integer]
  # @param height [Integer]
  # @param source [String]
  # @param format [String]
  # @return [ImageDto]
  def create_image(title:, content:, width:, height:, source:, format:)
    product = Product.create!(kind: 'image', title: title, content: content)
    details = ImageDetail.create!(product: product, width: width, height: height, source: source, format: format)
    build_image_dto(product, details)
  end

  # @param title [String]
  # @param content [String]
  # @param duration [Integer]
  # @param quality [String]
  # @return [VideoDto]
  def create_video(title:, content:, duration:, quality:)
    product = Product.create!(kind: 'video', title: title, content: content)
    details = VideoDetail.create!(product: product, duration: duration, quality: quality)
    build_video_dto(product, details)
  end

  # @param id [Integer]
  # @param title [String]
  # @param purchase_price [Float]
  # @return [nil]
  def update_book(id:, title:, purchase_price:)
    Product.update(id, title: title)
    BookDetail.where(product: id).update(purchase_price: purchase_price)
  end

  private

  # @param products [Array<Product>]
  # @return [Array<[BookDto, ImageDto, VideoDto]>]
  def fetch_details(products)
    grouped_products = products.group_by(&:kind)
    book_details = hash_by(BookDetail.where(product: grouped_products['book']).to_a, :product_id)
    image_details = hash_by(ImageDetail.where(product: grouped_products['image']).to_a, :product_id)
    video_details = hash_by(VideoDetail.where(product: grouped_products['video']).to_a, :product_id)
    products.map { |product| build_product_dto(product, book_details, image_details, video_details) }
  end

  BookDto = Struct.new(:id, :kind, :title, :content, :isbn, :purchase_price, :is_hot) do
    def fold(book:, image:, video:)
      book.respond_to?(:call) ? book.call(self) : book
    end
  end
  ImageDto = Struct.new(:id, :kind, :title, :content, :width, :height, :source, :format) do
    def fold(book:, image:, video:)
      image.respond_to?(:call) ? image.call(self) : image
    end
  end
  VideoDto = Struct.new(:id, :kind, :title, :content, :duration, :quality) do
    def fold(book:, image:, video:)
      video.respond_to?(:call) ? video.call(self) : video
    end
  end

  # @param array [Array<T>]
  # @param attr [Symbol]
  # @return [{Integer: T[]}]
  def hash_by(array, attr)
    Hash[array.collect { |value| [value[attr], value] }]
  end

  # @param product [Product]
  # @param book_details [{product_id: BookDetail}]
  # @param image_details [{product_id: ImageDetail}]
  # @param video_details [{product_id: VideoDetail}]
  # @return [BookDto, ImageDto, VideoDto]
  def build_product_dto(product, book_details, image_details, video_details)
    if product.kind == 'book'
      build_book_dto(product, book_details[product.id] || (raise "Missing details for book #{product.id.inspect}"))
    elsif product.kind == 'image'
      build_image_dto(product, image_details[product.id] || (raise "Missing details for image #{product.id.inspect}"))
    elsif product.kind == 'video'
      build_video_dto(product, video_details[product.id] || (raise "Missing details for video #{product.id.inspect}"))
    else
      raise "Unknown product kind #{product.kind.inspect}"
    end
  end

  # @param product [Product]
  # @param details [BookDetail]
  # @return [BookDto]
  def build_book_dto(product, details)
    BookDto.new(product.id, product.kind, product.title, product.content, details.isbn, details.purchase_price, details.is_hot)
  end

  # @param product [Product]
  # @param details [ImageDetail]
  # @return [ImageDto]
  def build_image_dto(product, details)
    ImageDto.new(product.id, product.kind, product.title, product.content, details.width, details.height, details.source, details.format)
  end

  # @param product [Product]
  # @param details [VideoDetail]
  # @return [VideoDto]
  def build_video_dto(product, details)
    VideoDto.new(product.id, product.kind, product.title, product.content, details.duration, details.quality)
  end
end
