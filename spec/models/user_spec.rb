require 'rails_helper'

RSpec.describe User, type: :model do
  
  it "has the username set correctly" do
    user = User.new username: "Aku Ankka"

    expect(user.username).to eq("Aku Ankka")
  end

  describe "is not saved if" do
    it "a password is missing" do
        user = User.create username: "Aku Ankka"
    
        expect(user).not_to be_valid
        expect(User.count).to eq(0)
    end

    it "or password is too short" do
      user = User.create username: "Aku Ankka", password: "1A", password_confirmation: "1A"

      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end

    it "or password does not contain numbers and capitals" do
      user = User.create username: "Aku Ankka", password: "3veljenpoikaa", password_confirmation: "3veljenpoikaa"
      user2 = User.create username: "Hannu Hanhi", password: "OnniPotkii", password_confirmation: "OnniPotkii"
      
      expect(user).not_to be_valid
      expect(user2).not_to be_valid

      expect(User.count).to eq(0)
    end
  end

  describe "with a proper password" do
    let(:user) { User.create username: "Aku Ankka", password: "3Veljenpoikaa", password_confirmation: "3Veljenpoikaa" }
    let(:test_brewery) { Brewery.new name: "test", year: 2022 }
    let(:test_beer) {Beer.create name: "Testbeer", style: "testStyle", brewery: test_brewery }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      rating = Rating.new score: 10, beer: test_beer
      rating2 = Rating.new score: 20, beer: test_beer

      user.ratings << rating
      user.ratings << rating2

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end
end
