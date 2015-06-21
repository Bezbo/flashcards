class CardsController < ApplicationController
  before_action :load_card, only: [:show, :edit, :update, :destroy]

  def index
    @cards = current_user.cards
  end

  def show
  end

  def new
    @card = current_user.cards.new
  end

  def create
    @card = current_user.cards.new(card_params)

    if @card.save
      redirect_to @card
    else
      render "new"
    end
  end

  def edit
  end

  def update
    if @card.update(card_params)
      redirect_to @card
    else
      render "edit"
    end
  end

  def destroy
    @card.destroy
    redirect_to cards_path(@cards)
  end

  private

  def card_params
    params.require(:card).permit(:original_text, :translated_text, :review_date, :image)
  end

  def load_card
    @card = current_user.cards.find(params[:id])
  end
end
