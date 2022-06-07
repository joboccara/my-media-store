class NewsletterJob < ApplicationJob
  def perform(mail_sender)
    products = ProductRepository.new.get_all_products
    mail_contents = products.group_by{|product| product[:kind]}.map do |kind, products|
      <<~PRODUCT
        #{kind}s
        #{products.map{|product| product_section(product)}.join("\n")}
      PRODUCT
    end.join
    mail_sender.send_newsletter(mail_contents)
  end

  private

  def product_section(product)
    details =  case product[:kind]
    when 'book' then "#{product[:isbn]}"
    when 'image' then "#{product[:width]}x#{product[:height]}"
    when 'video' then "#{product[:duration]} seconds"
    else raise "Unknown product kind #{product[:kind]}"
    end
    "#{product[:title]} - #{details}"
  end
end