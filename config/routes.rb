Rails.application.routes.draw do

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    registrations: 'users/registrations'
  }

  root 'homes#top'
  get '/about' => 'homes#about'

  resources :users, only: [:show, :edit, :update, :index] do
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end

  resources :posts, only: [:index, :show, :create, :update, :destroy, :edit] do
    resource :likes, only: [:create, :destroy]
  end

  resources :tags, except: [:index, :create, :new, :edit, :show, :update, :destroy] do
    get 'posts' => 'posts#search'
  end

  resources :chats, only: [:show, :create]
end
