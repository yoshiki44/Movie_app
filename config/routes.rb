Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  devise_scope :user do
    post 'users/guest_login', to: 'users/sessions#guest_login'
  end
  resources :movies, only: [:index ,:show]
  root 'movies#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :favorites, only: [:create, :destroy]
end
