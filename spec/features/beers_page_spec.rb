require 'rails_helper'

include Helpers

describe "Beer" do

    before :each do
       FactoryBot.create(:brewery)
       FactoryBot.create(:user)
       sign_in({ username: "Aku Ankka", password: "3Veljenpoikaa" })
    end

   it "with valid name can be created" do
    visit beers_path
    click_link("New beer")

    fill_in("beer_name", with: "Great Beer")    
    expect{ click_button("Create Beer") }.to change{Beer.count}.by(1)
   end

   it "with invalid name is not created and gives proper error message" do
    visit beers_path
    click_link("New beer")

    beer_count = Beer.count    
    click_button("Create Beer")
    expect(page).to have_content("Name can't be blank")
    expect(Beer.count).to eq(beer_count)
   end 

end

