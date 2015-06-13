class Card < ActiveRecord::Base
  validates :original_text,
            :translated_text,
            :review_date, presence: true
  validate :check_original_and_translated_texts
  before_create :set_default_review_date
  scope :for_review, -> { where("review_date <= ?", Date.today) }

  def check_original_and_translated_texts
    if strip_downcase(original_text) == strip_downcase(translated_text)
      errors.add(:translated_text, "не может быть равен оригиналу")
    end
  end

  def set_default_review_date
    self.review_date = 3.days.from_now
  end

  def compare_translation(input)
    if strip_downcase(original_text) == strip_downcase(input)
      update_attributes(review_date: 3.days.from_now)
    else
      return false
    end
  end

  def strip_downcase(text)
    text.mb_chars.downcase.strip
  end
end
