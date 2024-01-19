class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      session[:user_name] = user.name
      redirect_to list_sales_sales_path, notice: 'Login bem-sucedido!'
    else
      flash.now[:alert] = 'Email ou senha inválidos'
      render :new
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to new_session_path, notice: 'Logout bem-sucedido!'
  end

  private
  
  def set_login_page_flag
    @login_page = true
  end
end
