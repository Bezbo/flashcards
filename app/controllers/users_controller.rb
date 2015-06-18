class UsersController < ApplicationController
  skip_before_filter :require_login, only: [:index, :new, :create]
  before_action :load_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      login(user_params[:email], user_params[:password])
      redirect_to root_path
      flash[:success] = "Добро пожаловать"
    else
      render "new"
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user
    else
      render "edit"
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path(@users)
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def load_user
    @user = User.find(params[:id])
  end
end
