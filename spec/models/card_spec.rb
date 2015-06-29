require "rails_helper"

describe Card do
  let(:card) { create(:card) }

  it "is valid with proper parameters" do
    expect(card).to be_valid
  end

  it "is invalid without an original text" do
    card.original_text = ""
    expect(card).not_to be_valid
  end

  it "is invalid without a translated text" do
    card.translated_text = ""
    expect(card).not_to be_valid
  end

  it "is invalid without a user_id" do
    card.user_id = nil
    expect(card).not_to be_valid
  end

  it "is invalid without a deck_id" do
    card.deck_id = nil
    expect(card).not_to be_valid
  end

  it "is invalid without a review date" do
    card.review_date = nil
    expect(card).not_to be_valid
  end

  it "is invalid with same texts" do
    card.translated_text = "original_text"
    expect(card).not_to be_valid
  end

  it "sets default review date" do
    expect(card.review_date.strftime("%Y-%m-%d %H:%M")).
      to eq(Time.zone.now.strftime("%Y-%m-%d %H:%M"))
  end

  it ".strip_downcase" do
    card.original_text = " КоТ"
    a = card.strip_downcase(card.original_text)
    expect(a).to eq("кот")
  end

  context ".compare_translation" do
    before { card.review_date = Date.today - 10.days }

    it "returns true if texts match" do
      a = card.compare_translation(card.original_text)
      expect(a).to be true
    end

    it "returns false if texts not match" do
      a = card.compare_translation("invalid_text")
      expect(a).to be false
    end

    it "updates date if true" do
      card.compare_translation(card.original_text)
      expect(card.review_date.strftime("%Y-%m-%d %H:%M")).
        to eq((Time.zone.now + 12.hours).strftime("%Y-%m-%d %H:%M"))
    end

    it "doesn't update date if false" do
      card.compare_translation("invalid_text")
      expect(card.review_date).to eq(Date.today - 10.days)
    end

    it "update tries if false" do
      card.compare_translation("invalid_text")
      expect(card.try).to eq(2)
    end

    it "doesn't update tries if true" do
      card.compare_translation(card.original_text)
      expect(card.try).to eq(1)
    end
  end

  describe ".set_review_date_by_stage" do
    it "sets review date according to stage" do
      card.update_attributes(stage: 3)
      card.set_review_date_by_stage
      expect(card.review_date.strftime("%Y-%m-%d %H:%M")).
        to eq((Time.zone.now + 1.week).strftime("%Y-%m-%d %H:%M"))
    end

    context "if stage less then 5" do
      it "adds 1 to stage" do
        card.set_review_date_by_stage
        expect(card.stage).to eq(2)
      end
    end

    context "if stage equal 5" do
      it "doesn't add value to stage" do
        card.update_attributes(stage: 5)
        card.set_review_date_by_stage
        expect(card.stage).to eq(5)
      end
    end
  end

  describe ".set_tries" do
    context "if tries less then 3" do
      it "adds 1 to tries" do
        card.set_tries
        expect(card.try).to eq(2)
      end
    end

    context "if tries more then 3" do
      before { card.update_attributes(try: 3) }
      before { card.set_tries }

      it "sets tries to 1" do
        expect(card.try).to eq(1)
      end

      it "sets stage to 1" do
        expect(card.stage).to eq(1)
      end

      it "sets review_date to today + 12 hours" do
        expect(card.review_date.strftime("%Y-%m-%d %H:%M")).
          to eq((Time.zone.now + 12.hours).strftime("%Y-%m-%d %H:%M"))
      end
    end
  end
end
