Rails.application.routes.draw do
  resources :downloads, only: %i[create index]
  resources :products, onlu: %i[index]
end
