require "test_helper"

class NewsletterMailerTest < ActionMailer::TestCase
  # https://guides.rubyonrails.org/testing.html#testing-your-mailers
  test "books of the week" do
    user = User.create(first_name: 'Bob', email: 'bob@example.com')
    NewsletterMailer.new.books_of_the_week_email(user, [])
  end
end
