class Brewery < ApplicationRecord
  include RatingAverage

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validates :name, presence: true
  validates :year, numericality: { 
                    only_integer: true
                   }
  validate :year_is_in_valid_range

  def year_is_in_valid_range
    if year < 1040 || year > Date.today.year
        errors.add(:year, "must in range 1040-#{Date.today.year}")
    end
  end
end
