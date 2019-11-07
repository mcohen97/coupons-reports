class AddAgeRangeToCountByAgeRange < ActiveRecord::Migration[6.0]
  def change
    add_reference :count_by_age_ranges, :age_range, null: false, foreign_key: true
  end
end
