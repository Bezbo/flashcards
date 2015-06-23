require "rails_helper"
include SignInHelper

feature "Review" do
  let(:user) { FactoryGirl.create(:user) }
  let(:card) { FactoryGirl.create(:card, user_id: user.id) }
  let(:current_deck) { FactoryGirl.create(:deck, user_id: user.id) }
  let(:card_from_current_deck) {
    FactoryGirl.create(:card, translated_text: "current_deck",
                              deck_id: current_deck.id,
                              user_id: user.id) }
  let(:another_card) { FactoryGirl.create(:card, user_id: another_user.id) }
  let(:another_user) { FactoryGirl.create(:user, email: "another@example.com") }
  before { sign_in(user) }

  scenario "user can review only own card" do
    another_card.update_attributes(review_date: Date.today - 10.days)
    visit new_review_path
    expect(page).to have_content("На сегодня карточек нет")
  end

  context "if card for review present" do
    before { card.update_attributes(review_date: Date.today - 10.days) }
    before { visit new_review_path }

    scenario "show card text" do
      expect(page).to have_content(card.translated_text)
    end

    scenario "correct answer" do
      fill_in "review_user_input", with: card.original_text
      click_button "Правильно?"
      expect(page).to have_content("Абсолютно!")
    end

    scenario "incorrect answer" do
      fill_in "review_user_input", with: "incorrect_text"
      click_button "Правильно?"
      expect(page).to have_content("Конечно же нет!")
    end

    context "with current deck" do
      before { user.update_attributes(current_deck_id: current_deck.id) }
      before { card_from_current_deck.update_attributes(review_date:
                                                        Date.today - 10.days) }
      before { visit new_review_path }

      scenario "show card from current deck" do
        expect(page).to have_content(card_from_current_deck.translated_text)
      end

      scenario "do not show card from another deck" do
        expect(page).not_to have_content(card.translated_text)
      end
    end
  end

  context "if card for review not present" do
    before { card.review_date = Date.today + 10.days }

    scenario "show message" do
      visit new_review_path
      expect(page).to have_content("На сегодня карточек нет")
    end
  end
end
