class User < ActiveRecord::Base
  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end
  has_many :cards, dependent: :destroy
  has_many :decks, dependent: :destroy
  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications
  validates :password, length: { minimum: 3 }, on: :create
  validates :password, confirmation: true
  validates :password_confirmation, presence: true, on: :create
  validates :email, uniqueness: true

  def cards_for_review(user)
    if user.current_deck_id.present?
      decks.current_deck(user).first.cards.for_review.order("RANDOM()").first
    else
      cards.for_review.order("RANDOM()").first
    end
  end
end
