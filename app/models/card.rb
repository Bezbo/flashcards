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

  scope :for_review, -> do
    where("review_date <= ?", Time.now).order("RANDOM()")
  end

  def check_original_and_translated_texts
    if strip_downcase(original_text) == strip_downcase(translated_text)
      errors.add(:translated_text, "не может быть равен оригиналу")
    end
  end

  def set_default_review_date
    self.review_date = Time.now
  end

  def compare_translation(input)
    dl = DamerauLevenshtein
    distance = dl.distance(strip_downcase(original_text), strip_downcase(input))
    if distance <= 1
      set_review_date_by_stage
      { state: true, distance: distance }
    else
      set_attempts
      { state: false }
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
    new_review_attributes = { review_date: Time.now + time_by_stage,
                              attempt: 1 }
    new_review_attributes.merge!(stage: stage + 1) if stage < 5
    update_attributes(new_review_attributes)
  end

  def set_attempts
    new_review_attributes = { attempt: attempt + 1 }
    new_review_attributes.merge!(
      attempt: 1,
      stage: 1,
      review_date: Time.now + 12.hours) if attempt >= 3
    update_attributes(new_review_attributes)
  end
end
