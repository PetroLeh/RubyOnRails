class Beer < ApplicationRecord
  belongs_to :brewery
  has_many :ratings

  def average_rating
    avg = 0
    self.ratings.each {|rating|
        avg = avg + rating.score
    }
    (avg / self.ratings.count).to_f
  end

end
