require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:beer1) { FactoryBot.create :beer, name: "iso 3", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name: "Karhu", brewery:brewery }
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in({ username: "Aku Ankka", password: "3Veljenpoikaa" })
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select("iso 3", from: "rating[beer_id]")
    fill_in("rating[score]", with: "15")

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "is shown in ratings page" do
    FactoryBot.create(:rating, score: 10, beer: beer1, user: user)
    FactoryBot.create(:rating, score: 20, beer: beer2, user: user)

    visit ratings_path
    expect(page).to have_content("Ratings: 2")
    expect(page).to have_content("#{beer1.name} 10 #{user.username}")
    expect(page).to have_content("#{beer2.name} 20 #{user.username}")
  end

  it "is removed from database when deleted" do
    FactoryBot.create(:rating, score: 10, beer: beer1, user: user)
    expect(Rating.count).to eq(1)
    visit user_path(user)
    expect(page).to have_content("Has made 1 rating")

    click_link("delete")
    visit user_path(user)
    expect(page).to have_content("Has made 0 ratings")    
    expect(Rating.count).to eq(0)
  end
end