require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new( name: "Oljenkorsi", id: 1 ) ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if several are returned by the API, they all are shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("huvikumpu").and_return(
      [ Place.new( name: "Pitkätossun majatalo", id: 1 ),
        Place.new( name: "Pitkäjussin majatalo", id: 2 ),
        Place.new( name: "Puolimatkan krouvi", id: 3 ) ]
    )

    visit places_path
    fill_in('city', with: 'huvikumpu')
    click_button "Search"

    expect(page).to have_content "Pitkätossun majatalo"
    expect(page).to have_content "Pitkäjussin majatalo"
    expect(page).to have_content "Puolimatkan krouvi"
  end

  it "if none is returned by the API, a relevant message is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("pikku kakkonen").and_return(
        []
      )
  
      visit places_path
      fill_in('city', with: 'pikku kakkonen')
      click_button "Search"
  
      expect(page).to have_content "No locations in pikku kakkonen"  
  end
end