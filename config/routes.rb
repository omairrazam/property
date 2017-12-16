Rails.application.routes.draw do

#  get 'stocks/index'
get '/stocks' => 'stocks#index', :as => :stocks
  resources :installments

  resources :transactions
  resources :plot_files
  resources :regions
  resources :categories
  get 'homes/index'


  devise_for :users, :skip => :registrations
devise_scope :user do
  resource :registration,
    :only => [:new, :create, :edit, :update],
    :path => 'users',
    :path_names => { :new => 'sign_up' },
    :controller => 'devise/registrations',
    :as => :user_registration do
      get :cancel
    end
end
resources :users
  root "homes#index"
end
