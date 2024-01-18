class ApplicationController < ActionController::Base
  include UsersHelper
  helper_method :current_user, :logged_in?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def require_login
    redirect_to login_path unless logged_in?
  end

  def logged_in?
    !!current_user
  end
end