class ReviewsController < ApplicationController
  def new
    @random_card = Card.for_review.order("RANDOM()").first
  end

  def create
    card = Card.find(input_params[:card_id])
    if card.compare_translation(input_params[:user_input])
      flash[:success] = "Абсолютно!"
    else
      flash[:warning] = "Конечно же нет!"
    end
    redirect_to new_review_path
  end

  private

  def input_params
    params.require(:translation_matching).permit(:user_input, :card_id)
  end
end