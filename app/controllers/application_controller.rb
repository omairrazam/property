class ApplicationController < ActionController::Base
   before_action :set_paper_trail_whodunnit
#  protect_from_forgery with: :exception
#  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  #for enum non existing value
  rescue_from ArgumentError, with: :handle_bad_params

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:username, :email, :password,
        :password_confirmation, :cnic, :address, :phone, :avatar, :avatar_cache, :remove_avatar) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:username, :email, :password,
        :password_confirmation, :cnic, :address, :phone, :current_password, :avatar, :avatar_cache, :remove_avatar) }
  end

  def after_sign_up_path_for(user)
    '/users' # replace with the path you want
  end

  def handle_bad_params(exception)
  	render json: {error: exception.message}.to_json, status: 404
  end
end
