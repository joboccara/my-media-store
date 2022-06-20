# frozen_string_literal: true
class Pricing::BookPricer

  def initialize(default_purchase_price, now)
    @default_purchase_price = default_purchase_price
    @now = now
  end

  def call(book)
    isbn_price(book) ||
      hot_book_price(book) ||
      default_price(book)
  end

  private

  def isbn_price(book)
    isbn_repository[book.isbn][:price].to_f if isbn_repository[book.isbn].present?
  end

  def hot_book_price(book)
    9.99 if book.is_hot && @now.on_weekday?
  end

  def default_price(book)
    (book.purchase_price || @default_purchase_price) * 1.25
  end

  def isbn_repository
    repository_file_path = Rails.root.join('app/assets/config/isbn_prices.csv')
    return {} unless File.exist?(repository_file_path)
    @_isbn_repository ||= CSV.read(repository_file_path, headers: true, header_converters: :symbol)
                             .index_by { |entry| entry[:isbn] }
  end
end
