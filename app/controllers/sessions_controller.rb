class SessionsController < ApplicationController
  # skip_before_action :require_login, only: [:new, :create]
  
  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to list_sales_sales_path, notice: 'Login bem-sucedido!'
    else
      flash.now[:alert] = 'Email ou senha inválidos'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: 'Logout bem-sucedido!'
  end
end
