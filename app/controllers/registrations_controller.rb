class RegistrationsController < ApplicationController
  skip_before_action :require_login

  def new
    @user = User.new
    redirect_to root_path if current_user
  end

  def create
    @user = User.new(user_params)

    if @user.save
      login(user_params[:email], user_params[:password])
      redirect_to root_path
      flash[:success] = t("welcome")
    else
      render "new"
    end
  end

  private

  def user_params
    params.require(:user).permit(:email,
                                 :password,
                                 :password_confirmation,
                                 :locale)
  end
end
