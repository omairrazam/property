class ApplicationController < ActionController::Base
  #protect_from_forgery with: :exception
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

  def handle_bad_params(exception)
  	render json: {error: exception.message}.to_json, status: 404
  	return
  end
end
