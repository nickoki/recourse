Rails.application.routes.draw do
<<<<<<< HEAD
=======
  mount_devise_token_auth_for 'User', at: 'auth'
  devise_for :users
>>>>>>> 87bcc0da954ed6d9d5cc026a2e407ac07211c394
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
