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

Now the situation is clear, have a look to [instructions/iteration1.md](instructions/iteration1.md).
Please do not look at instructions ahead of time, you will spoil you and ruin the training ^^
