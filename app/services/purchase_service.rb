class PurchaseService
  # @param product_repo [ProductRepository]
  # @param download_repo [DownloadRepository]
  # @param invoice_repo [InvoiceRepository]
  # @param price_calculator [PriceCalculator]
  # @return [PurchaseService]
  def initialize(product_repo, download_repo, invoice_repo, price_calculator)
    @product_repo = product_repo
    @download_repo = download_repo
    @invoice_repo = invoice_repo
    @price_calculator = price_calculator
  end

  # @param user_id [Integer]
  # @param product_id [Integer]
  # @param now [Time]
  # @return [Result<nil>]
  def purchase(user_id, product_id, now)
    product = @product_repo.get_product(product_id)
    @price_calculator.price(product.to_h, now).then do |price|
      @download_repo.create(user_id, product.id)
      @invoice_repo.create(user_id, product, price)
    end
  end
end
