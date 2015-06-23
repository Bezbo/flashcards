class DecksController < ApplicationController
  before_action :load_deck, only: [:show, :edit, :destroy]

  def index
    @decks = current_user.decks.all
  end

  def show
  end

  def new
    @deck = current_user.decks.new
  end

  def create
    @deck = current_user.decks.new(deck_params)
    if @deck.save
      redirect_to decks_path
    else
      render "new"
    end
  end

  def edit
  end

  def update
    if @deck.update(deck_params)
      redirect_to @deck
    else
      render "edit"
    end
  end

  def destroy
    @deck.destroy
    redirect_to decks_path(@decks)
  end

  private

  def deck_params
    params.require(:deck).permit(:name)
  end

  def load_deck
    @deck = current_user.decks.find(params[:id])
  end
end
