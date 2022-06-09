Rails.application.routes.draw do
  resources :downloads, only: %i[create index]
  resources :catalogs, only: %i[show]
  resources :product_prices, only: %i[show]
  resources :products, only: %i[index show]
  resources :purchases, only: %i[index create]
  get 'price_simulation', to: 'price_simulations#compute'
end
