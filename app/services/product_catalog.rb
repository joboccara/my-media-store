class ProductCatalog
  # @param path [String]
  # @return [ProductCatalog]
  def initialize(path)
    rails_path = Rails.root.join(path)
    if File.exist?(rails_path)
      _csv_header, *csv_rows = CSV.read(rails_path)
      @prices_by_isbn = csv_rows.to_h { |row| [row[0], row[1].to_f] }
    else
      @prices_by_isbn = {}
    end
  end

  # @param isbn [String]
  # @return [Float, nil]
  def get_price(isbn)
    @prices_by_isbn[isbn]
  end
end
