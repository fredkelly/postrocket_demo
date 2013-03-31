class ApplicationController < ActionController::Base
  protect_from_forgery
  check_authorization
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to(root_url, alert: exception.message)
  end
  
  rescue_from RuntimeError do |exception|
    flash[:error] = exception.message unless Rails.env.production?
  end
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session.has_key?(:user_id)
  end
  helper_method :current_user
  
end
