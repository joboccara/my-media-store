Rails.application.routes.draw do
  get 'item/index'
  resources :downloads, only: %i[create index]
  resources :items, only: %i[index]
end
