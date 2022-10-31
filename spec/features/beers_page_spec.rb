require 'rails_helper'

include Helpers

describe "Beer" do

    before :each do
       brewery = FactoryBot.create(:brewery)
    end

   it "can be created" do
    visit beers_path
    click_link("New beer")

    fill_in("beer_name", with: "Great Beer")
    save_and_open_page
    
    expect{ click_button("Create Beer") }.to change{Beer.count}.by(1)
   end
end

