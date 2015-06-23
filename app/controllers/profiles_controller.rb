class ProfilesController < ApplicationController

  def show
  end

  def edit
  end

  def update
    if current_user.update(user_params)
      redirect_to profile_path
    else
      render "edit"
    end
  end

  def set_current_deck
    if current_user.update_attributes(current_deck_id: params[:deck_id])
      flash[:success] = "Основная колода выбрана"
    else
      flash[:warning] = "Выбрать основную колоду не удалось"
    end
    redirect_to decks_path
  end

  private

  def user_params
    params.require(:profile).permit(:email,
                                    :password,
                                    :password_confirmation,
                                    :current_deck_id)
  end
end
