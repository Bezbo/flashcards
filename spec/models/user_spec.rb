require "rails_helper"

describe User do
  let(:user) { create(:user) }
  let(:invalid_user) { build(:user) }

  it "is valid with proper parameters" do
    expect(user).to be_valid
  end

  it "is invalid if email already has taken" do
    user
    expect(invalid_user).not_to be_valid
  end

  it "is invalid if password is too short" do
    invalid_user.password = "123"
    expect(invalid_user).not_to be_valid
  end

  it "is invalid if password is not confirmed" do
    invalid_user.password_confirmation = ""
    expect(invalid_user).not_to be_valid
  end

  it "is invalid if confirmation does not match" do
    invalid_user.password_confirmation = "wrong"
    expect(invalid_user).not_to be_valid
  end
end
