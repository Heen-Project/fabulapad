Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :categories
  resources :comments, only: [:create]
  resources :users, except: [:new]

  # Stories
  resources :stories
  get 'subscribed', to: 'stories#subscribed', as: 'subscribed'
  delete '/comments/:id', to: 'comments#destroy', as: 'delete_comment'

  # Static pages
  root 'pages#home'

  ## Session
  get 'signup', to: 'users#new'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  ## Follow feature
  post '/users/:id/follow', to: 'users#follow', as: 'follow_user'
  post '/users/:id/unfollow', to: 'users#unfollow', as: 'unfollow_user'
  get '/users/:id/follower', to: 'users#follower', as: 'follower'
  get '/users/:id/following', to: 'users#following', as: 'following'
  
end
