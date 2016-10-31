Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Define Devise routes, extend the RegistrationsController to custom AuthenticationsController
  devise_for :users

  # Route to authenticate user and assign JWT
  post 'auth_user' => 'authentications#authenticate_user'

  # Define Posts controller routes
  resources :posts

  # Set root controller route
  root to: "posts#index"

end
