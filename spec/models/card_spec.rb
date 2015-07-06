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
    downcased_card_text = card.strip_downcase(card.original_text)
    expect(downcased_card_text).to eq("кот")
  end

  context ".compare_translation" do
    before { card.review_date = Date.today - 10.days }

    it "returns true if texts match" do
      comparison_result = card.compare_translation(card.original_text)
      expect(comparison_result[:state]).to be true
    end

    it "returns true if texts have minor typo" do
      comparison_result = card.compare_translation(card.original_text + "a")
      expect(comparison_result[:state]).to be true
    end

    it "returns false if texts not match" do
      comparison_result = card.compare_translation("invalid_text")
      expect(comparison_result[:state]).to be false
    end

    it "returns false if texts have major typo" do
      comparison_result = card.compare_translation(card.original_text + "aa")
      expect(comparison_result[:state]).to be false
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

    it "update attempts if false" do
      card.compare_translation("invalid_text")
      expect(card.attempt).to eq(2)
    end

    it "doesn't update attempts if true" do
      card.compare_translation(card.original_text)
      expect(card.attempt).to eq(1)
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

  describe ".set_attempts" do
    context "if attempts less then 3" do
      it "adds 1 to attempts" do
        card.set_attempts
        expect(card.attempt).to eq(2)
      end
    end

    context "if attempts more then 3" do
      before { card.update_attributes(attempt: 3, stage: 3) }
      before { card.set_attempts }

      it "sets attempts to 1" do
        expect(card.attempt).to eq(1)
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

  describe "#pending_cards" do
    let(:user_with_cards) { create(:user) }

    it "returns users with cards for review" do
      card.update_attributes(user_id:     user_with_cards.id,
                             review_date: Time.now - 10.days)
      expect(Card.pending_cards).to include(user_with_cards)
    end

    it "doesn't return users without cards for review" do
      expect(Card.pending_cards).not_to include(user_with_cards)
    end

    it "sends notification mail to users with cards for review" do
      card.update_attributes(user_id:     user_with_cards.id,
                             review_date: Time.now - 10.days)
      expect { Card.pending_cards }.to change {
        ActionMailer::Base.deliveries.count }.by(1)
    end

    it "doesn't send notification mail to users without cards for review" do
      expect { Card.pending_cards }.to change {
        ActionMailer::Base.deliveries.count }.by(0)
    end
  end
end
