class Card < ActiveRecord::Base
  belongs_to :user
  belongs_to :deck

  has_attached_file :image, styles: { medium: "360x360>" }

  validates_attachment_file_name :image, matches: [/png\Z/, /jpe?g\Z/]
  validates :original_text,
            :translated_text,
            :user_id,
            :deck_id,
            :review_date, presence: true
  validate :check_original_and_translated_texts

  before_create :set_default_review_date

  scope :for_review, -> {
    where("review_date <= ?", Time.now).order("RANDOM()") }

  def check_original_and_translated_texts
    if strip_downcase(original_text) == strip_downcase(translated_text)
      errors.add(:translated_text, "не может быть равен оригиналу")
    end
  end

  def set_default_review_date
    self.review_date = Time.now
  end

  def compare_translation(input)
    if strip_downcase(original_text) == strip_downcase(input)
      set_review_date_by_stage
      return true
    else
      set_tries
      return false
    end
  end

  def strip_downcase(text)
    text.mb_chars.downcase.strip
  end

  def set_review_date_by_stage
    time_by_stage = case stage
                    when 1 then 12.hours
                    when 2 then 3.days
                    when 3 then 1.weeks
                    when 4 then 2.weeks
                    when 5 then 1.months
                    end
    update_attributes(review_date: Time.now + time_by_stage, try: 1)
    if stage < 5
      update_attributes(stage: stage + 1)
    end
  end

  def set_tries
    update_attributes(try: try + 1)
    if try > 3
      update_attributes(try: 1, stage: 1, review_date: Time.now + 12.hours)
    end
  end
end
