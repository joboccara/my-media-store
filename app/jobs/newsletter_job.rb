class NewsletterJob < ApplicationJob
  # https://edgeguides.rubyonrails.org/active_job_basics.html
  queue_as :default

  def perform(*args)
    now = Time.new
    products = ProductRepository.new
    mailer = NewsletterMailer.new
    books = products.books_of_week(now)
    User.find_each do |user|
      mailer.books_of_the_week_email(user, books).deliver_now
    end
  end
end
