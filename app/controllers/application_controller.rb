class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :logged_in?

  def current_user=(user)
    session[:user]=user
  end
  def current_user
    session[:user]||nil
  end

  def logged_in?
    return false if current_user.blank?
    return true
end
  
    
  def login_required?
    redirect_to login_url unless logged_in?
    return true
  end
  
end
