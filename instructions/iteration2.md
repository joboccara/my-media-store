# Iteration 2: add specific details

We noticed that we miss some meaningful information to sell our products.
Let's add them:
- books: isbn (ex: 0321721330), purchase_price (float), is_hot (boolean)
- images: width (int), height (int), source (unknown, Getty, NationalGeographic), format (jpg, png, raw)
- videos: duration (int in seconds), quality (4k, SD, FullHD)

We want to see them in the `products_controller#index` endpoint.
And oh, `created_at` and `updated_at` fields should not be exposed anymore, and of course, not the `purchase_price` also ^^.

Unskip test from `iteration_2_test` and fix what it's needed.
