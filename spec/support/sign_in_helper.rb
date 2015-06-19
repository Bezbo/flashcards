module SignInHelper
  def sign_in
    visit root_path
    click_link "Вход"
    fill_in "Email", with: user.email
    fill_in "Password", with: "secret"
    click_button "Login"
  end

  def sign_up
    visit root_path
    click_link "Регистрация"
    fill_in "Email", with: "email@example.com"
    fill_in "Password", with: "secret"
    fill_in "Password confirmation", with: "secret"
    click_button "Create User"
  end
end
