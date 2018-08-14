Rails.application.routes.draw do
  resources :all_notices
  root 'homes#index'
  
  get 'homes/back2'
  # back2는 실험용 뷰
  
  get 'homes/index'
  
  get 'users/page/:id' => 'users#page'
  
  get 'bulletin/:id/posts' => 'posts#index'
  
  post '/tinymce_assets' => 'tinymce_assets#create'
  
  resources :posts
  resources :bulletins do
    resources :posts
  end
  
  resources :comments do
    member do
      put "like" => "comments#upvote"
    end
  end
  
  devise_for :users
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # 이 줄 아래로는 내용 쓰지 마시오 (devise랑 코드 혼선 발생 우려) 
end