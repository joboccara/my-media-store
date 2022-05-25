Rails.application.routes.draw do
  resources :downloads, only: %i[create index]
end
