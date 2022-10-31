require 'rails_helper'

RSpec.describe User, type: :model do

    describe "favorite beer" do
        let(:user) { FactoryBot.create(:user) }

        it "has method for determining one" do
          expect(user).to respond_to(:favorite_beer)
        end

        it "without ratings does not have one" do
          expect(user.favorite_beer).to eq(nil)
        end

        it "is the only rated if only one rating" do
            beer = FactoryBot.create(:beer)
            rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)
            expect(user.favorite_beer).to eq(beer)
        end

        it "is the one with highest rating if several rated" do
            create_beers_with_many_ratings({ user: user }, 10, 15, 20, 25)
            best = create_beer_with_rating({ user: user }, 30)
            expect(user.favorite_beer).to eq(best)
        end
    end

    describe "favorite style" do
        let(:user) { FactoryBot.create(:user) }

        it "has method for determinig one" do
          expect(user).to respond_to(:favorite_style)
        end

        it "without ratings does not have one" do
          expect(user.favorite_style).to eq(nil)
        end

        it "is the style of only rated if only one rating" do
          beer = create_beer_with_rating({ user: user, style: "IPA" }, 10)
          expect(user.favorite_style).to eq(beer.style)
        end

        it "is the style with highest average rating if several rated" do
          create_beers_with_many_ratings({ user: user, style: "IPA" }, 10, 15, 20, 31)

          favorite = "Porter"
          create_beers_with_many_ratings({ user: user, style: favorite}, 25, 30)

        end

    end
    
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
    let(:user) { FactoryBot.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      FactoryBot.create(:rating, score: 10, user: user)
      FactoryBot.create(:rating, score: 20, user: user)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  def create_beer_with_rating(object, score)
    beer = FactoryBot.create(:beer, style: object[:style] || "lager")     
    FactoryBot.create(:rating, beer: beer, score: score, user: object[:user])
    beer
  end

  def create_beers_with_many_ratings(object, *scores)
    scores.each do |score|
      create_beer_with_rating(object, score)
    end
  end
end
