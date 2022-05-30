Rails.application.routes.draw do
  resources :downloads, only: %i[create index]
  resources :catalogs, only: %i[show]
  resources :products, only: %i[show]
  post '/products/simulate', to: 'products#simulate', as: 'product_simulate'
end
