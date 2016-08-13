Rails.application.routes.draw do
  resources :shipments
  resources :addresses
  resources :products
  resources :addresss
  resources :warehouses
  root 'home#index'
end
