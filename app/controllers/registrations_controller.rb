# controllers/registrations_controller.rb

class RegistrationsController < Devise::RegistrationsController

  skip_before_action :verify_authenticity_token

  clear_respond_to

  respond_to 'json'

  def create
    binding.pry
    build_resource
    @user = User.new(user_params)
    binding.pry
    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        return render :json => {:success => true}
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        return render :json => {:success => true}
      end
    else
      clean_up_passwords resource
      return render :json => {:success => false}
    end
  end

  # Signs in a user on sign up. You can overwrite this method in your own
  # RegistrationsController.
  def sign_up(resource_name, resource)
    sign_in(resource_name, resource)
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation)
    # params.permit!
  end

end
