class PromotionOrganization < ApplicationRecord
  validates :promotion_id, uniqueness: true, presence: true
  validates :organization_id, presence: true
end
