require "rails_helper"
include SignInHelper

describe "sign up" do
  context "before sign up" do
    before { visit root_path }

    scenario "sign up link is present" do
      expect(page).to have_content("Регистрация")
    end

    scenario "sign out link is not present" do
      expect(page).not_to have_content("Выход")
    end

    scenario "no users in database" do
      expect(User.count).to eq(0)
    end

    scenario "card review is not available" do
      visit new_review_path
      expect(page).to have_content("Необходима авторизация")
    end
  end

  context "after sign up" do
    before { sign_up }

    scenario "sign up link is not present" do
      expect(page).not_to have_content("Регистрация")
    end

    scenario "sign out link is present" do
      expect(page).to have_content("Выход")
    end

    scenario "add user to database" do
      expect(User.count).to eq(1)
    end

    scenario "card review is available" do
      visit new_review_path
      expect(page).to have_content("На сегодня карточек нет")
    end
  end
end
