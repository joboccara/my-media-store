# My Media Store

This repo is for the Doctolib software design training.

We are managing an online shop for digital goods: books, images and videos.
The goal of the training will be to extend it.
The challenge will be to do it in a way that supports well future evolutions.

In order to facilitate the code and focus more on architecture decisions than implementation details, some tests are provided to clarify the API.
We also focus on backend code, so we only develop REST API, they will be used with tests.

## Getting started

- run `bundle install`

Tips:
- if you want/need to change models, you can update the migrations, it will be quicker/easier ;)

### Initial state

You have a `products_controller` allowing to list all the products by kind.
Users can browse them and download them. Their downloaded list is available in the `downloads_controller`.

### Iteration 1: compute price

Now we want to make money! Let's add some price to our items.
Price is available as a standalone endpoint, returning only the price for the required product.
See `product_prices_controller` and its test.

Here are the pricing options we want to use:
- books: we have a `BOOK_PURCHASE_PRICE` environment variable, just add +25% to compute the price
- images: the price is always 7
- videos: the price is 15 during the day (5AM - 10PM) and 9 otherwise
- all: if the title of the item contains "premium", increase the price by 5%

### Iteration 2: add specific details

We noticed that we miss some meaningful information to sell our products.
Let's add them:
- TODO

### Iteration 3: extend pricing strategies with new attributes

As we have new attributes, let's refine our pricing model.

### Iteration 4: pricing simulation

Some creators want to have a price simulation before adding their content to the store.
It's time to offer some transparency!

### Iteration 5: newsletter

Our store is full of goods to sell, but still has too few sales.
We can create a monthly newsletter recommending best books of the month to all our users.

### Iteration 6: purchase

Sales are growing, it's great. Customers are now asking invoices for their purchases.

