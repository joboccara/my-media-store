Rails.application.routes.draw do
  resources :downloads, only: %i[create index]
  resources :catalogs, only: %i[show]
  resources :products, only: %i[show]
end
