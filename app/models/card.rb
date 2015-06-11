class Card < ActiveRecord::Base
  validates :original_text,
            :translated_text,
            :review_date, presence: true
  validate :check_original_and_translated_texts

  def check_original_and_translated_texts
    if original_text.downcase.strip == translated_text.downcase.strip
      errors.add(:translated_text, "не может быть равен оригиналу")
    end
  end
end
