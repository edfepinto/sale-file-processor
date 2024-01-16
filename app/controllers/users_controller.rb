class UsersController < ApplicationController
  before_action :require_login, except: [:new, :create]

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
    @hide_back_link = params[:from_login].present?
  end

  def edit
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user), notice: "Usuário criado com sucesso!" }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
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

    private

    def require_login
      unless session[:user_id]
        flash[:alert] = 'Você precisa estar logado para acessar esta página.'
        redirect_to login_path
      end
    end
end
