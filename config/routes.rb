Rails.application.routes.draw do
  root 'static_pages#home'
  devise_for :users, skip: [:registrations]
  devise_scope :user do
    get 'signup', to: 'users#new', as: :new_user_registration
    get 'login', to: 'devise/sessions#new'
    post 'login', to: 'devise/sessions#create'
    get 'logout', to: 'devise/sessions#destroy'
    delete 'logout', to: 'devise/sessions#destroy'
  end
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
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
  resources :follows, only: [:create, :destroy]
end
