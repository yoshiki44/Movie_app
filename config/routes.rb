Rails.application.routes.draw do
  devise_for :users
  resources :movies, only: [:index ,:show]
  root 'movies#index'
  get '/home/top' => "home#top"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
