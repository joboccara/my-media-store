# Iteration 2: add specific details

We noticed that we miss some meaningful information to describe our products and sell them.
Let's add them:

- books: isbn (string, e.g. '9781603095099'), purchase_price (float), is_hot (boolean)
- images: width (int), height (int), source ('unknown', 'Getty', 'NationalGeographic'), format ('jpg', 'png', 'raw')
- videos: duration (int in seconds), quality (4k, SD, FullHD)

We want to retrieve them from the `products_controller#index` endpoint.
And oh, `created_at` and `updated_at` fields should not be exposed anymore, and of course, not the `purchase_price` also ^^.

Unskip tests from `iteration_2_test.rb` and fix what is needed.
