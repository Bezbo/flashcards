class Card < ActiveRecord::Base
  validates :original_text,
            :translated_text,
            :review_date, presence: true
  validate :check_original_and_translated_texts
  before_create :set_default_review_date

  def check_original_and_translated_texts
    if original_text.mb_chars.downcase.strip == translated_text.mb_chars.downcase.strip
      errors.add(:translated_text, "не может быть равен оригиналу")
    end
  end

  def set_default_review_date
    self.review_date = 3.days.from_now
  end
end
