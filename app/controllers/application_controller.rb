class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  #모바일 체크
  helper_method :mobile?
  
  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname, :profile_picture, :email, :password])
    devise_parameter_sanitizer.permit(:account_update, keys: [:nickname, :profile_picture, :email, :password, :current_password])
  end
  
  #모바일 검사
  private
  def mobile? # has to be in here because it has access to "request"
    request.user_agent =~ /\b(Android|iPhone|iPad|Windows Phone|Opera Mobi|Kindle|BackBerry|PlayBook)\b/i
  end
end
