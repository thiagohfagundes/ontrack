Rails.application.routes.draw do
  resources :templates
  devise_for :users
  resource :profile, only: [:show, :edit, :update]

  # Defines the root path route ("/")
  root "onboardings#index"

  resources :onboardings do
    resources :tasks do
      member do
        patch :toggle_status
      end
    end
    resources :participants, only: [:index, :new, :create, :destroy]
  end
end
