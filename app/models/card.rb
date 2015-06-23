class Card < ActiveRecord::Base
  belongs_to :user
  belongs_to :deck
  has_attached_file :image, styles: { medium: "360x360>" }
  validates :original_text,
            :translated_text,
            :user_id,
            :deck_id,
            :review_date, presence: true
  validate :check_original_and_translated_texts
  validates_attachment_file_name :image, matches: [/png\Z/, /jpe?g\Z/]
  before_create :set_default_review_date
  scope :for_review, -> { where("review_date <= ?", Date.today) }

  def check_original_and_translated_texts
    if strip_downcase(original_text) == strip_downcase(translated_text)
      errors.add(:translated_text, "не может быть равен оригиналу")
    end
  end

  def set_default_review_date
    self.review_date = Date.today + 3.days
  end

  def compare_translation(input)
    if strip_downcase(original_text) == strip_downcase(input)
      update_attributes(review_date: Date.today + 3.days)
    else
      return false
    end
  end

  def strip_downcase(text)
    text.mb_chars.downcase.strip
  end
end
