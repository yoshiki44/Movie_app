Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  devise_scope :user do
    post 'users/guest_login', to: 'users/sessions#guest_login'
  end
  resources :movies, only: [:index, :show] do
    resources :favorites, only: [:create]
  end
  resources :favorites, only: [:index, :destroy]
  root 'movies#index'
  get 'movies/search', to: 'movies#search', as: 'search_movies'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

end
