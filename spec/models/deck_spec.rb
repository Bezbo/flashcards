require "rails_helper"

describe Deck do
  let(:deck) { create(:deck) }

  it "is valid with proper parameters" do
    expect(deck).to be_valid
  end

  it "is invalid without a name" do
    deck.name = ""
    expect(deck).not_to be_valid
  end
end
