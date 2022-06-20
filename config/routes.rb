Rails.application.routes.draw do
  resources :products, only: %i[index]
  resources :downloads, only: %i[create index]
  get 'price_simulation', to: 'price_simulations#compute'
  resources :purchases, only: %i[index create]
end
