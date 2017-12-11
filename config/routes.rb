Rails.application.routes.draw do

  resources :transactions
  resources :plot_files
  resources :regions
  resources :categories
  get 'homes/index'

  devise_for :users, skip: [:registrations]
  resources :users
  root "homes#index"
end
