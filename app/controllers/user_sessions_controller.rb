class UserSessionsController < ApplicationController
  skip_before_filter :require_login, except: [:destroy]

  def new
    @user = User.new
    redirect_to root_path if current_user
  end

  def create
    if @user = login(params[:email], params[:password])
      redirect_back_or_to(:root)
      flash[:success] = "Вход выполнен успешно"
    else
      flash.now[:warning] = "Неверный Email или пароль"
      render action: 'new'
    end
  end

  def destroy
    logout
    redirect_to(:root)
    flash[:warning] = "Выход"
  end
end
