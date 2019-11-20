class AddIndexToCountByCountry < ActiveRecord::Migration[6.0]
  def change
    add_index :count_by_countries, :promotion_id, unique: true
  end
end
