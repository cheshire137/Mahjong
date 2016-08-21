Rails.application.routes.draw do
  devise_for :users, controllers: {registrations: 'users/registrations'}

  resources :games, only: [:index, :show] do
    collection do
      get :temporary
      post :temporary_match
    end
    member do
      post :match
    end
  end

  root to: 'login#index'
end
