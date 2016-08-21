Rails.application.routes.draw do
  devise_for :users, controllers: {registrations: 'users/registrations'}

  resources :games, only: [:index, :show] do
    collection do
      get :temporary
      post :temporary_match
      post :temporary_shuffle
      get :image
    end
    member do
      post :match
      post :shuffle
    end
  end

  root to: 'login#index'
end
