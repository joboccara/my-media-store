Rails.application.routes.draw do
  resources :downloads, only: %i[create index]
  resources :products, only: %i[index]
end
