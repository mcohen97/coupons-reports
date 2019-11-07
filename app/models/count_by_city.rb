class CountByCity < ApplicationRecord
  belongs_to :city
  validates :promotion_id, presence: true
  validates_uniqueness_of :promotion_id, scope: :city
  validates :count, numericality: { greater_than_or_equal_to: 0 }

end
