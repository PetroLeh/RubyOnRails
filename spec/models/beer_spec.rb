require 'rails_helper'

RSpec.describe Beer, type: :model do
    let(:test_brewery) { Brewery.new name: "test_brewery", year: 2022 }

    it "is saved with valid specs given" do
      beer = Beer.create name: "test_beer", style: "test_style", brewery: test_brewery
      
      expect(beer).to be_valid
      expect(Beer.count).to eq(1)
    end

    describe "is not saved if" do
        it "a name is not given" do
          beer = Beer.create style: "test_style", brewery: test_brewery

          expect(beer).not_to be_valid
          expect(Beer.count).to eq(0)
        end

        it "a style is not given" do
          beer = Beer.create name: "test_beer", brewery: test_brewery

          expect(beer).not_to be_valid
          expect(Beer.count).to eq(0)
        end
    end
end
