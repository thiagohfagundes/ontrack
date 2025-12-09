Rails.application.routes.draw do
  resources :emails
  resources :meetings
  resources :tasks
  resources :templates
  devise_for :users
  resource :profile, only: [:show, :edit, :update]

  # Defines the root path route ("/")
  root "onboardings#index"

  resources :onboardings do
    member do
      get :visibility
      patch :update_visibility
    end
    resources :tasks do
      member do
        patch :toggle_status
      end
    end
    resources :meetings
    resources :emails
    resources :participants, only: [:index, :new, :create, :destroy]
  end
end
