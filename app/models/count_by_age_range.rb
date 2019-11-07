class CountByAgeRange < ApplicationRecord
  belongs_to :age_range
  validates :promotion_id, presence: true
  validates_uniqueness_of :promotion_id, scope: :age_range
  validates :count, numericality: { greater_than_or_equal_to: 0 }
end
