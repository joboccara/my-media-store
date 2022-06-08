Rails.application.routes.draw do
  resources :products, only: %i[index]
  resources :downloads, only: %i[create index]
end
