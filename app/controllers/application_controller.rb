# controllers/application_controller.rb

class ApplicationController < ActionController::Base
  # Protect API from from suspicious sessions
  # protect_from_forgery unless: -> { request.format.json? }
  protect_from_forgery with: :null_session
  # protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  # Let our controller read the current_user
  attr_reader :current_user



  protected

    # Method to authenticate JWTs in API requests
    def authenticate_request!

      # Does JWT contain valid user_id?
      unless user_id_in_token?
        render json: { errors: ['Not Authenticated'] }, status: :unauthorized
        return
      end

      # Find user based on user_id in token
      @current_user = User.find(auth_token["user_id"])

    # Rescue exceptions raised in controller actions
    rescue JWT::VerificationError, JWT::DecodeError
      render json: { errors: ['Not Authenticated'] }, status: :unauthorized
    end



  private

    # HTTP Token (JWT) from request headers
    def http_token
      @http_token ||= if request.headers['Authorization'].present?
        request.headers['Authorization'].split(' ').last
      end
    end

    # authenticate HTTP Token using Auth Class
    def auth_token
      @auth_token ||= Auth.decode(http_token)
    end

    # Check for user_id in JWT
    def user_id_in_token?
      http_token && auth_token && auth_token[:user_id].to_i
    end
end
