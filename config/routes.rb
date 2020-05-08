Rails.application.routes.draw do
  # devise_for :users
  root 'static_pages#home'
  devise_scope :user do
    get 'signup', to: 'users#new'
    get 'login', to: 'devise/sessions#new'
    post 'login', to: 'devise/sessions#create'
    get 'logout', to: 'devise/sessions#destroy'
    delete 'logout', to: 'devise/sessions#destroy'
    # get 'signup', to: 'users/sign_up'
  end
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  # get '/signup', to: 'users#new'
  # get '/login', to: 'sessions#new'
  # post '/login', to: 'sessions#create'
  # delete '/logout', to: 'sessions#destroy'
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :posts, only: [:create, :destroy] do
    resources :comments, only: [:create, :destroy]
    resources :likes
  end
  resources :comments, only: [:create, :destroy]
  # , path: '/post/:id/comments'
  resources :follows, only: [:create, :destroy]
end
