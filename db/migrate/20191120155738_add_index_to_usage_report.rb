class AddIndexToUsageReport < ActiveRecord::Migration[6.0]
  def change
    add_index :usage_reports, :promotion_id, unique: true
  end
end
