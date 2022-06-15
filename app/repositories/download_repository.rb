class DownloadRepository
  # @param user_id [Integer]
  # @param product_id [Integer]
  # @return [nil]
  def create(user_id, product_id)
    Download.create!(user_id: user_id, product_id: product_id)
    nil
  end
end
