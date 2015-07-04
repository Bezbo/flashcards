class ReviewsController < ApplicationController
  def new
    @random_card = current_user.cards_for_review
  end

  def create
    @card = current_user.cards.find(review_params[:card_id])
    comparison = @card.compare_translation(review_params[:user_input])
    @comparison_result = { input: review_params[:user_input],
                           original: @card.original_text,
                           translate: @card.translated_text }
    if comparison[:state]
      if comparison[:typos_count] == 0
        flash.now[:success] = "Абсолютно!"
      else
        flash.now[:typo] = "Опечатка!"
      end
    else
      flash.now[:warning] = "Конечно же нет!"
    end
    render "new"
  end

  private

  def review_params
    params.require(:review).permit(:user_input, :card_id)
  end
end
