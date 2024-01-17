class UsersController < ApplicationController
  before_action :require_login, except: [:new, :create]
  before_action :require_admin, except: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
    @hide_back_link = params[:from_login].present?
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    reset_session

    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        log_in @user

        format.html { redirect_to list_sales_sales_path, notice: "Usuário criado e logado com sucesso!" }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def logout
    reset_session
    redirect_to login_path, notice: 'Você saiu com sucesso.'
  end

  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "Usuário atualizado com sucesso!" }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: "Usuário excluído com sucesso!" }
      format.json { head :no_content }
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :role)
  end

  def require_login
    unless session[:user_id]
      flash[:alert] = 'Você precisa estar logado para acessar esta página.'
      redirect_to login_path
    end
  end

  private

  def log_in(user)
    session[:user_id] = user.id
    session[:user_name] = user.name
  end

  private

  def require_admin
    unless current_user && current_user.admin?
      flash[:alert] = 'Acesso negado. Você não tem permissão para acessar essa página.'
      redirect_to root_path
    end
  end
end
