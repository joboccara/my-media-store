class NewsletterJob < ApplicationJob
  def perform(mail_sender)
    products = ProductRepository.new.get_products
    mail_content = format_newsletter(products)
    mail_sender.send_newsletter(mail_content)
  end

  private

  def format_newsletter(products)
    products.group_by(&:kind).map do |kind, kind_products|
      format_product_section(kind, kind_products)
    end.join
  end

  def format_product_section(kind, products)
    <<~PRODUCT
      #{kind}s
      #{products.map { |product| format_product(product) }.join("\n")}
    PRODUCT
  end

  def format_product(product)
    "#{product.title} - #{product.fold(
      book: proc { |b| "#{b.isbn}" },
      image: proc { |i| "#{i.width}x#{i.height}" },
      video: proc { |v| "#{v.duration} seconds" }
    )}"
  end
end
