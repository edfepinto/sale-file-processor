class ApplicationController < ActionController::Base
  before_action :require_login

  private

  def require_login
    unless session[:user_id]
      flash[:error] = 'Você precisa estar logado para acessar esta página.'
      redirect_to login_path
    end
  end
end

