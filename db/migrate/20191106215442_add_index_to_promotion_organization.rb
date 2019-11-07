class AddIndexToPromotionOrganization < ActiveRecord::Migration[6.0]
  def change
    add_index :promotion_organizations, :promotion_id, unique: true
  end
end