class NewsletterJob < ApplicationJob
  def perform(from:, to:, mail_sender:)
    @products = Products::Catalog.new.for_period(from: Date.parse(from), to: Date.parse(to)).group_by { |product| product.kind }

    newsletter = ''
    if books.any?
      newsletter += "Books\n"
      books.each {|book| newsletter << newsletter_row([book.title, book.isbn], book.price) }
    end
    if images.any?
      newsletter += "Images\n"
      images.each {|image| newsletter << newsletter_row([image.title, "#{image.width}x#{image.height}"], image.price) }
    end
    if videos.any?
      newsletter += "Videos\n"
      videos.each {|video| newsletter << newsletter_row([video.title, "#{video.duration} seconds"], video.price) }
    end
    mail_sender.send_newsletter(newsletter)
  end

  private

  def newsletter_row(attributes, price)
    "* #{(attributes + ["#{'%.2f' % price}"]).join(' - ')}\n"
  end

  def books
    @products['Book']
  end

  def images
    @products['Image']
  end

  def videos
    @products['Video']
  end
end
