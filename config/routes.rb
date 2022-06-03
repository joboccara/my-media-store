Rails.application.routes.draw do
  resources :downloads, only: %i[create index]
  resources :products, only: %i[index]
  resources :price_simulator, only: %i[show]
end
