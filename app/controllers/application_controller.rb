class ApplicationController < ActionController::Base
<<<<<<< HEAD
  protect_from_forgery with: :null_session

  attr_reader :current_user

  protected
    def authenticate_request!
      unless user_id_in_token?
        render json: { errors: ['Not Authenticated'] }, status: :unauthorized
        return
      end
      @current_user = User.find(auth_token["user_id"])
    rescue JWT::VerificationError, JWT::DecodeError
      render json: { errors: ['Not Authenticated'] }, status: :unauthorized
    end

  private
    def http_token
      @http_token ||= if request.headers['Authorization'].present?
        request.headers['Authorization'].split(' ').last
      end
    end

    def auth_token
      @auth_token ||= Auth.decode(http_token)
    end

    def user_id_in_token?
      http_token && auth_token && auth_token[:user_id].to_i
    end
=======
  include DeviseTokenAuth::Concerns::SetUserByToken
  protect_from_forgery with: :exception
>>>>>>> 87bcc0da954ed6d9d5cc026a2e407ac07211c394
end
