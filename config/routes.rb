Rails.application.routes.draw do
  devise_for :users

  resources :games, only: [:index, :show]

  root to: 'login#index'
end
