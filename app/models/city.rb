class City < ApplicationRecord
  belongs_to :country
  validates_uniqueness_of :name, scope: :country
end
