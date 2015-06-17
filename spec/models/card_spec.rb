require "rails_helper"

describe Card do
  let(:card) { FactoryGirl.create(:card) }

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

  it "is invalid without a review date" do
    card.review_date = nil
    expect(card).not_to be_valid
  end

  it "is invalid with same texts" do
    card.translated_text = "original_text"
    expect(card).not_to be_valid
  end

  it "sets default review date" do
    expect(card.review_date).to eq(Date.today + 3.days)
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
      expect(card.review_date).to eq(Date.today + 3.days)
    end

    it "doesn't update date if false" do
      card.compare_translation("invalid_text")
      expect(card.review_date).to eq(Date.today - 10.days)
    end
  end
end
