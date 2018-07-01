Rails.application.routes.draw do
  resources :all_notices
  root 'homes#index'
  
  get 'homes/index'
  
  get 'users/page/:id' => 'users#page'
  
  resources :posts
  resources :bulletins do
    resources :posts
  end
  
  devise_for :users
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
end
