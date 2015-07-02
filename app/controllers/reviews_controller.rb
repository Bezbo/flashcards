class ReviewsController < ApplicationController
  include ReviewsHelper

  def new
    @random_card = current_user.cards_for_review
  end

  def create
    card = current_user.cards.find(review_params[:card_id])
    comparison = card.compare_translation(review_params[:user_input])

    if comparison[:state]
      typo_helper(card, comparison)
    else
      flash[:warning] = "Конечно же нет!"
    end
    redirect_to new_review_path
  end

  private

  def review_params
    params.require(:review).permit(:user_input, :card_id)
  end
end
