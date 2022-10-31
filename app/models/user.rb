class User < ApplicationRecord
  include RatingAverage

  has_secure_password

  validates :username, uniqueness: true,
                       length: { in: 3..30 }
  validate :password_validation

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  def password_validation
    if password.nil? || password.length < 4
      errors.add(:password, "has to be at least 4 characters long")
    elsif !password.match(/[A-Z]/)
      errors.add(:password, "has to contain at least one capital letter (A-Z)")
    elsif !password.match(/\d/)
      errors.add(:password, "has to contain at least one number (0-9)")
    end
  end

  def favorite_beer
    return nil if ratings.empty?

    ratings.max_by(&:score).beer
  end

  def favorite_style
    return nil if ratings.empty?

    ratings.first.beer.style
  end
end
