class NewsletterMailer < ApplicationMailer
  # https://guides.rubyonrails.org/action_mailer_basics.html
  default from: 'notifications@example.com'

  # @param user [User]
  # @param books [ProductRepository::BookDto[]]
  # @return [Mail]
  def books_of_the_week_email(user, books)
    @user = user
    @books = books
    mail(to: @user.email, subject: 'Best books of the week')
  end
end
