require 'rails_helper'

describe User do
  let(:user) { FactoryGirl.create(:user) }
  let(:invalid_user) { FactoryGirl.build(:user) }

  it "is valid with proper parameters" do
    expect(user).to be_valid
  end

  it "is invalid if email already taken" do
    user
    expect(invalid_user).not_to be_valid
  end

  it "is invalid if password too short" do
    invalid_user.password = "123"
    expect(invalid_user).not_to be_valid
  end

  it "is invalid if password not confirmed" do
    invalid_user.password_confirmation = ""
    expect(invalid_user).not_to be_valid
  end

  it "is invalid if confirmation does not match" do
    invalid_user.password_confirmation = "wrong"
    expect(invalid_user).not_to be_valid
  end
end
