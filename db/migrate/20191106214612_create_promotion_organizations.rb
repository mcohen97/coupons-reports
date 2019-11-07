class CreatePromotionOrganizations < ActiveRecord::Migration[6.0]
  def change
    create_table :promotion_organizations do |t|
      t.integer :promotion_id
      t.integer :organization_id

      t.timestamps
    end
  end
end
