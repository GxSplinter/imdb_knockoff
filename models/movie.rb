class Movie < ActiveRecord::Base
  validates :name, presence: true
  validates :rating, inclusion: { in: (1..5) }
end
