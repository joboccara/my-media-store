Rails.application.routes.draw do
  resources :downloads, only: %i[create index]
  resources :catalogs, only: %i[show]
  resources :products, only: %i[show]
  resources :purchases, only: %i[index create]
end
