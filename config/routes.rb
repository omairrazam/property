Rails.application.routes.draw do
  resources :transactions
  resources :plot_files
  resources :regions
  resources :categories
  get 'homes/index'

  devise_for :users
  root "homes#index"
end
