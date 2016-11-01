# config/routes.rb

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Set root controller route
  root to: "posts#index"

  # Define Posts controller routes
  namespace :api do
    resources :posts do
      member do
        post 'favorite' => "posts#add_favorite"
        delete 'favorite' => "posts#remove_favorite"
      end
    end
  end

  # Define Devise routes, extend the RegistrationsController to custom AuthenticationsController
  devise_for :users

  # Route to authenticate user and assign JWT
  post 'auth_user' => 'authentications#authenticate_user'

  # Route
end
