# Iteration 3: extend pricing strategies using new attributes

As we have new attributes, let's refine our pricing model:

- books:
  - compute price with +25% from `purchase_price` instead of the environment variable
  - if the book is_hot, its price should be 9.99 during weekdays
  - if book is present in `app/assets/config/isbn_prices.csv`, get it from there instead
- images
  - if source is 'NationalGeographic', the price is 0.02/9600px
  - if source is 'Getty'
    - price is 1 when same or fewer pixels than 1280x720
    - price is 3 when same or fewer pixels than 1920x1080
    - price is 5 otherwise
    - expect if format is 'raw', price is 10 whatever the size
  - otherwise, price is 7
- videos
  - '4k' videos are priced at 0.08/second
  - 'FullHD' videos are priced at 3 per started minute
  - 'SD' videos are priced at 1 per started minute
  - time over 10 minutes is not accounted for 'SD' videos
  - for other formats, price is 15
  - video price is reduced by 40% during the night (22 PM - 5 AM)
- still have the +5% price increase for any book or video containing 'premium' in the title (from iteration 1)

Unskip tests from `iteration_3_test.rb` and fix what is needed.
