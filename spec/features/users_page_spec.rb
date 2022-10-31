require 'rails_helper'

include Helpers

describe "User" do
    let!(:user) { FactoryBot.create :user }

    it "when signed up with good credentials, is added to the system" do
        visit signup_path
        fill_in('user_username', with: 'Brian')
        fill_in('user_password', with: 'Secret55')
        fill_in('user_password_confirmation', with: 'Secret55')
      
        expect{
          click_button('Create User')
        }.to change{User.count}.by(1)
    end

    describe "who has signed up" do
        it "can signin with right credentials" do
            sign_in({ username: "Aku Ankka", password: "3Veljenpoikaa" })

            expect(page).to have_content "Welcome back!"
            expect(page).to have_content "Aku Ankka"
        end

        it "is redirected back to signin form if wrong credentials given" do
            sign_in({ username: "Aku Ankka", password: "2Veljenpoikaa" })

            expect(current_path).to eq(signin_path)
            expect(page).to have_content "Username and/or password mismatch"
        end
    end

    describe "who is signed in" do

      it "can see only own ratings in users page" do
        user2 = FactoryBot.create(:user, username: "Hannu Hanhi", password: "Onnekas2", password_confirmation: "Onnekas2")
        
        create_beer_with_rating({ user: user2 }, 20)

        create_beers_with_many_ratings({ user: user }, 20, 30)
        expect(Rating.count).to eq(3)

        sign_in({ username: "Aku Ankka", password: "3Veljenpoikaa" })
        expect(page).to have_content("Has made 2 ratings, average rating 25.0")
      end

    end
end