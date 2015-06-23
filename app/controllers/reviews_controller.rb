class ReviewsController < ApplicationController
  def new
    if current_deck.present?
      @random_card = current_deck.cards.for_review.order("RANDOM()").first
    else
      @random_card = current_user.cards.for_review.order("RANDOM()").first
    end
  end

  def create
    card = current_user.cards.find(review_params[:card_id])
    if card.compare_translation(review_params[:user_input])
      flash[:success] = "Абсолютно!"
    else
      flash[:warning] = "Конечно же нет!"
    end
    redirect_to new_review_path
  end

  def current_deck
    current_user.decks.where("id = ?", current_user.current_deck_id).first
  end

  private

  def review_params
    params.require(:review).permit(:user_input, :card_id)
  end
end
