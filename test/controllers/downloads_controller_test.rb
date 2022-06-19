require "test_helper_training"

class DownloadsControllerTest < TestHelperTraining
  test 'a downloaded item appears in the library' do
    user = User.create!(first_name: 'Bob')
    book_to_download_1 = create_book(title: 'A Philosophy of Software Design', content: 'Contents of Book1')
    book_to_download_2 = create_book(title: 'Head First Design Patterns', content: 'Contents of Book2')
    book_not_to_download = create_book(title: 'The Mikado Method', content: 'Contents of Book3')

    post downloads_url, params: { user_id: user.id, item_id: book_to_download_1.id }
    post downloads_url, params: { user_id: user.id, item_id: book_to_download_2.id }

    get downloads_url, params: { user_id: user.id }

    downloaded_books = response.parsed_body['books']
    assert_equal 2, downloaded_books.count
    assert_equal 'A Philosophy of Software Design', downloaded_books[0]['title']
    assert_equal 'Contents of Book1', downloaded_books[0]['content']
    assert_equal 'Head First Design Patterns', downloaded_books[1]['title']
    assert_equal 'Contents of Book2', downloaded_books[1]['content']
  end

  test 'a user can download an item only once' do
    user = User.create!(first_name: 'Bob')
    book_to_download = create_book(title: 'Radical Candor', content: 'Contents of Book')

    post downloads_url, params: { user_id: user.id, item_id: book_to_download.id }
    assert_response :success

    post downloads_url, params: { user_id: user.id, item_id: book_to_download.id }
    assert_response :bad_request
  end
end
