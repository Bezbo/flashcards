FactoryGirl.define do
  factory :user do
    email "email@example.com"
    password "secret"
    password_confirmation "secret"
  end

end
