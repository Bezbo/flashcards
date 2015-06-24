class Deck < ActiveRecord::Base
  belongs_to :user
  has_many :cards, dependent: :destroy
  validates :name, presence: true
  scope :current_deck, ->(user) { where("id = ?", user.current_deck_id) }
end
