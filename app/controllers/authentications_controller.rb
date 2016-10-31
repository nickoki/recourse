# app/controllers/authentications_controller.rb
class AuthenticationsController < Devise::SessionsController

  skip_before_action :authenticate

  def create

    super



    user = User.find_by(email: auth_params[:email])
    p "USER: #{user}"
    # If user can be authenticated, generate JWT from lib/auth.rb
    # if user.authenticate(auth_params[:password])
      # Encrypt unique user id (instead of sensitive data, like email or password)
      jwt = Auth.issue({user: user.id})
      # Send JWT back to fornt-end, store in localStorage
      p "JWT: #{jwt}"
    # else
    # end
  end

  private
    def auth_params
      # params.require(:auth).permit(:email, :password)
      params.require(:user).permit(:email, :password)
    end

end
