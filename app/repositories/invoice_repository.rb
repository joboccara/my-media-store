class InvoiceRepository
  # @param user_id [Integer]
  # @return [Array<InvoiceDto>]
  def get_user_invoices(user_id)
    Invoice.where(user_id: user_id).to_a.map { |invoice| build_invoice_dto(invoice) }
  end

  # @param user_id [Integer]
  # @param product [BookDto, ImageDto, VideoDto]
  # @param price [Float]
  # @return [InvoiceDto]
  def create(user_id, product, price)
    invoice = Invoice.create!(user_id: user_id, product_id: product.id, title: product.title, price: price)
    build_invoice_dto(invoice)
  end

  private

  InvoiceDto = Struct.new(:id, :user, :product, :title, :price)

  # @param invoice [Invoice]
  # @return [InvoiceDto]
  def build_invoice_dto(invoice)
    InvoiceDto.new(invoice.id, invoice.user_id, invoice.product_id, invoice.title, invoice.price)
  end
end
