require "rails_helper"

feature "Review" do
  let(:card) { FactoryGirl.create(:card) }

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
  end

  context "if card for review not present" do
    before { card.review_date = Date.today + 10.days }

    scenario "show message" do
      visit new_review_path
      expect(page).to have_content("На сегодня карточек нет")
    end
  end
end