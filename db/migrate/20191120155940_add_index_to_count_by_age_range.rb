class AddIndexToCountByAgeRange < ActiveRecord::Migration[6.0]
  def change
    add_index :count_by_age_ranges, :promotion_id, unique: true
  end
end
