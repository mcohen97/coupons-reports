class AgeRange < ApplicationRecord

  MAX_AGE = 100

  validates :from, numericality: { greater_than: 0 }
  validates :from, numericality: { less_than: ->(range) { range.to }}
  validates :to, numericality: { less_than: MAX_AGE }

end
