Rails.application.routes.draw do
  get 'searches/index'

  resources :all_notices
  root 'homes#index'
  
  get 'homes/back2'
  # back2는 실험용 뷰
  
  get 'homes/index'
  
  get 'homes/messages_box' => 'homes#messages_box'
  
  post 'homes/messages_box.:user' => 'homes#messages_box'

  get 'users/page/:id' => 'users#page'
  
  get 'bulletin/:id/posts' => 'posts#index'
  
  post '/tinymce_assets' => 'tinymce_assets#create'
  
  resources :posts
  
  resources :bulletins do
    resources :posts
    post "/posts/:post_id/restore", to: "posts#restore"
  end
  
  resources :comments do
    member do
      put "like" => "comments#upvote"
    end
  end
  
  # 알림 : 전체 삭제
  get '/new_notifications/read_all' => 'new_notifications#read_all'
  # 알림
  resources :new_notifications

  get 'conversations.:user_id' => 'conversations#create'
  
  devise_for :users
  
  resources :conversations, only: [:create] do
    member do
      post :close
    end
    resources :messages, only: [:create]
  end
  
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # 이 줄 아래로는 내용 쓰지 마시오 (devise랑 코드 혼선 발생 우려) 
end