class OauthsController < ApplicationController
  skip_before_action :require_login

  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]
    if @user = login_from(provider)
      flash[:success] = t(".login_via_provider_success", provider: provider)
      redirect_to root_path
    else
      begin
        @user = create_from(provider)
        reset_session
        auto_login(@user)
        flash[:success] = t(".login_via_provider_success", provider: provider)
        redirect_to root_path
      rescue
        flash[:warning] = t(".login_via_provider_fail", provider: provider)
        redirect_to root_path
      end
    end
  end

  private

  def auth_params
    params.permit(:code, :provider)
  end
end
