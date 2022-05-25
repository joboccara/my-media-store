require 'test_helper'

class DownloadsControllerTest < ActionDispatch::IntegrationTest
  test 'a downloaded item appears in the library' do
    user = User.create(first_name: 'Bob')
    book_to_download_1 = Item.create(kind: 'book', title: 'Title of Book1', content: 'Contents of Book1')
    book_to_download_2 = Item.create(kind: 'book', title: 'Title of Book2', content: 'Contents of Book2')
    book_not_to_download = Item.create(kind: 'book', title: 'Title of Book3', content: 'Contents of Book3')

    post downloads_url, params: { user_id: user.id, item_id: book_to_download_1.id }
    post downloads_url, params: { user_id: user.id, item_id: book_to_download_2.id }

    get downloads_url, params: { user_id: user.id, format: :json }

    downloaded_books = response.parsed_body['books']
    assert_equal 2, downloaded_books.count
    assert_equal 'Title of Book1', downloaded_books[0]['title']
    assert_equal 'Contents of Book1', downloaded_books[0]['content']
    assert_equal 'Title of Book2', downloaded_books[1]['title']
    assert_equal 'Contents of Book2', downloaded_books[1]['content']
  end

  test 'a user can download an item only once' do
    user = User.create(first_name: 'Bob')
    book_to_download = Item.create(kind: 'book', title: 'Title of Book', content: 'Contents of Book')

    post downloads_url, params: { user_id: user.id, item_id: book_to_download.id }
    assert_response :success

    post downloads_url, params: { user_id: user.id, item_id: book_to_download.id }
    assert_response :bad_request
  end
end
