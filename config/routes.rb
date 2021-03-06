Rails.application.routes.draw do

  get 'password_resets/new'

  get 'password_resets/edit'

    root 'static_pages#home'
    get  '/help',    to: 'static_pages#help'
    get  '/about',   to: 'static_pages#about'
    get  '/contact', to: 'static_pages#contact'
    get '/signup',  to: 'users#new'
    post '/signup', to: 'users#create'
    get '/login', to: 'sessions#new'
    post '/login', to: 'sessions#create'
    delete '/logout', to: 'sessions#destroy'
    resources :users do
      member do
        get :following, :followers, :likes
      end
    end
    get '/search', to: 'users#search'
    get '/protein', to: 'users#protein'
    get '/wear', to: 'users#wear'
    get '/training_items', to: 'users#training_items'
    get '/others', to: 'users#others'
    resources :account_activations, only: [:edit]
    resources :password_resets, only: [:new, :create, :edit, :update]
    resources :microposts,          only: [:new, :create, :destroy]
    resources :relationships,       only: [:create, :destroy]
    
  #like機能拡張用に指定
  resources :likes, only: [:create, :destroy]
end
