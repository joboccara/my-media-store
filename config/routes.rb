Rails.application.routes.draw do
  resources :products, only: %i[index]
  resources :downloads, only: %i[create index]
  resources :product_prices, only: %i[show]
end
