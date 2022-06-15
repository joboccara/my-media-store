# repositories offer a business abstraction to access data, models should only be used inside them
class ProductRepository
  # @param id [Integer]
  # @return [ProductDto]
  def get_product(id)
    product = Product.find(id)
    raise "Product #{id.inspect} not found" if product.nil?
    build_product_dto(product)
  end

  private

  ProductDto = Struct.new(:id, :kind, :title, :content)

  # @param product [Product]
  # @return [ProductDto]
  def build_product_dto(product)
    ProductDto.new(product.id, product.kind, product.title, product.content)
  end
end
