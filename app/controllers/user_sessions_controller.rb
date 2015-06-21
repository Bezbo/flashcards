class UserSessionsController < ApplicationController
  skip_before_action :require_login, except: [:destroy]

  def new
    @user = User.new
    redirect_to root_path if current_user
  end

  def create
    if @user = login(params[:email], params[:password])
      flash[:success] = "Вход выполнен успешно"
      redirect_back_or_to(:root)
    else
      flash.now[:warning] = "Неверный Email или пароль"
      render action: 'new'
    end
  end

  def destroy
    logout
    flash[:warning] = "Выход"
    redirect_to(:root)
  end

  private

  def load_user
    @user = User.find(params[:id])
  end
end
