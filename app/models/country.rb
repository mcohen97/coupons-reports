class Country < ApplicationRecord
  has_many :cities
  validates :name, uniqueness: true, presence: true
end
