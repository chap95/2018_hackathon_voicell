Rails.application.routes.draw do
    root 'homes#index'
    
    get 'homes/index'
    
    get 'users/page/:id' => 'users#page'
    
    devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
