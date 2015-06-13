class HomeController < ApplicationController
  def index
    @random_card = Card.for_review.order("RANDOM()").first
  end

  def compare
    card = Card.find(input_params[:card_id])
    if card.compare_translation(input_params[:input])
      flash[:success] = "Абсолютно!"
    else
      flash[:warning] = "Конечно же нет!"
    end
    redirect_to root_path
  end

  private

  def input_params
    params.require(:translation_matching).permit(:input, :card_id)
  end
end
