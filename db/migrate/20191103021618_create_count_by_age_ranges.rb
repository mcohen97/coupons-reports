class CreateCountByAgeRanges < ActiveRecord::Migration[6.0]
  def change
    create_table :count_by_age_ranges do |t|
      t.integer :promotion_id
      t.integer :count, default: 0

      t.timestamps
    end
  end
end
