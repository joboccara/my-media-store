# Iteration 1: compute price

Now we want to make money! Let's add some price to our items.
Product price is displayed in the products list.

Here are the pricing rules we want to use:

- books: we have a `BOOK_PURCHASE_PRICE` environment variable, just add +25% to compute the price
- images: the price is always 7
- videos: the price is 15 during the day (5AM - 10PM) and 9 otherwise
- books and videos only: if the title of the item contains "premium" with any capitalization, increase the price by 5%

Unskip tests from `iteration_1_test.rb` and fix what is needed.
