# Iteration 1: compute price

Now we want to make money! Let's add some price to our items.
Price is available as a standalone endpoint, returning only the price for the required product.

Here are the pricing options we want to use:
- books: we have a `BOOK_PURCHASE_PRICE` environment variable, just add +25% to compute the price
- images: the price is always 7
- videos: the price is 15 during the day (5AM - 10PM) and 9 otherwise
- all: if the title of the item contains "premium", increase the price by 5%

Unskip test from `iteration_1_test` and fix what it's needed.
