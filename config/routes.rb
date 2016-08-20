Rails.application.routes.draw do
  devise_for :users

  resources :games, only: [:index, :show] do
    member do
      post :match
    end
  end

  root to: 'login#index'
end
