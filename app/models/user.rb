class User < ActiveRecord::Base
  authenticates_with_sorcery!
  has_many :cards, dependent: :destroy
  validates :password, length: { minimum: 3 }, on: :create
  validates :password, confirmation: true
  validates :password_confirmation, presence: true, on: :create
  validates :email, uniqueness: true
end
