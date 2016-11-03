# app/controllers/authentications_controller.rb

require_relative '/lib/auth.rb'

class AuthenticationsController < ApplicationController

  # Method to authenticate user
  def authenticate_user

    # Find user based on email
    user = User.find_for_database_authentication(email: params[:email])

    # Check password, render payload
    if user && user.valid_password?(params[:password])
      render json: payload(user)
    else
      render json: { errors: ['Invalid Username/Password'] }, status: :unauthorized
    end
  end



  private

    # Create token payload
    def payload(user)
      return nil unless user and user.id
      {
        auth_token: Auth.issue({ user_id: user.id }),
        user: { id: user.id, email: user.email }
      }
    end

end
