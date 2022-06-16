# Iteration 4: pricing simulation

Some creators want to have a price simulation before adding their content to the store.
It's time to offer more transparency!

In this iteration, we will add an endpoint (`price_simulation_controller#compute`) to compute the price of an item, only from its given attributes.
Some attributes are optional such as `title` or `is_hot` as they have a clear default (`false`) on pricing.
Make sure to return good errors like defined in the tests ;)

Unskip tests from `iteration_4_test.rb` and fix what is needed.
