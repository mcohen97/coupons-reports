class CountByCountry < ApplicationRecord
  belongs_to :country
  validates :promotion_id, presence: true
  validates_uniqueness_of :promotion_id, scope: :country
  validates :count, numericality: { greater_than_or_equal_to: 0 }
end
