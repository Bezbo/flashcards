class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_locale
  before_action :require_login

  def default_url_options(options={})
    { locale: I18n.locale }
  end

  private

  def not_authenticated
    flash[:warning] = t("login_please")
    redirect_to login_path
  end

  def set_locale
    if current_user
      I18n.locale = current_user.locale
    else
      I18n.locale = params[:locale] || extract_locale_from_accept_language_header
    end
    Rails.application.routes.default_url_options[:locale] = I18n.locale
  end

  def extract_locale_from_accept_language_header
    case request.env["HTTP_ACCEPT_LANGUAGE"].scan(/^[a-z]{2}/).first
    when "ru"
      "ru"
    else
      "en"
    end
  end
end
