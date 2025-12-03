Rails.application.routes.draw do
  resources :onboardings
  devise_for :users
  resource :profile, only: [:show, :edit, :update]

  # Defines the root path route ("/")
  root "onboardings#index"
end
